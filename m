Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1ESOnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:43:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:49816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1ESOnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:43:49 -0400
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
In-Reply-To: <20110519141456.GB1956@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
	 <20110519073136.GB14049@liondog.tnic> <1305793931.2466.7191.camel@twins>
	 <20110519141456.GB1956@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 16:43:28 +0200
Message-ID: <1305816208.2466.7223.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 16:14 +0200, Frederic Weisbecker wrote:
> 
> Great. I kept it global because I read in a review from you
> that you wanted it to stay a visible API. But if you're fine
> with it internal, let's move it there. 

Well, its needed as an external symbol, but the inline isn't needed.

I thought that the BTS code used it as well, but apparently that code
doesn't anymore (or never did any my memory if fuzzy).
