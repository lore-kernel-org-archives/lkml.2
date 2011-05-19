Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1ESIcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:32:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:45789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1ESIcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:32:33 -0400
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20110519073136.GB14049@liondog.tnic>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
	 <20110519073136.GB14049@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 10:32:11 +0200
Message-ID: <1305793931.2466.7191.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 09:31 +0200, Borislav Petkov wrote:
> 
> Ok, maybe I'm missing something looking at this from the side but
> perf_output_copy is used only internally by perf_event.c, i.e.
> events/core.c, why not put it into the internal.h header?

Not strictly true, but since the current inline is only valid for the
existing perf_event.c its close enough :-)

Anyway, I agree, stick it in internal.h :-)
