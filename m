Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1EKQSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:18:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab1EKQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:18:07 -0400
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110511121135.GA25865@aftab>
References: <20110511121135.GA25865@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 15:46:40 +0200
Message-ID: <1305121600.2914.214.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 14:11 +0200, Borislav Petkov wrote:
>  include/linux/perf_event.h |  138 ++++++++++++-

I don't like exposing all that in a kernel wide header.. should we maybe
have kernel/events/internal.h?

