Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0CZV2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:28:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426Ab0CZV2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:28:02 -0400
Date: Fri, 26 Mar 2010 14:23:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Protect prefetch macro arguments.
In-Reply-To: <4BAD248D.7070603@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1003261421470.3721@i5.linux-foundation.org>
References: <1269636240-8895-1-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1003261402170.3721@i5.linux-foundation.org> <4BAD248D.7070603@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Mar 2010, David Daney wrote:

> On 03/26/2010 02:04 PM, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 26 Mar 2010, David Daney wrote:
> > > 
> > > The GCC built-in __builtin_prefetch() is a vargs function.  If we
> > > don't wrap the macro parameter in parentheses, a comma operator in the
> > > actual argument list might cause unintended parameters to be passed to
> > > __builtin_prefetch().
> > 
> > This seems totally pointless and actively wrong.
> 
> Pointless, perhaps.  But 'actively wrong'?  Are you sure about that?

Yes, I'm sure about that.

Your commit message was actively misleading, and the end result is worse 
than the original and shows a lack of understanding of the C preprocessor. 

IOW, very much "actively wrong".

		Linus
