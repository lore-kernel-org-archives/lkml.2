Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0FHRuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:50:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755979Ab0FHRuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:50:18 -0400
Date: Tue, 8 Jun 2010 10:50:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
Message-Id: <20100608105018.f7f82a1e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
	<alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 10:41:28 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Jun 2010, Dave Chinner wrote:
> >
> > Can you please consider this patch series for 2.6.35?
> 
> Yeah, no. See the several lkml discussions and the -rc2 announcement about 
> how I do _not_ intend to merge anything even remotely "new code" this time 
> around.
> 
> So purely regression fixes and serious bugfixes (oopses/security issues).

Linus would have merged it.

> 			Kubys

But his evil twin got ahold of the keyboard.
