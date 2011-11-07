Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1KHG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:26:21 -0500
Received: from ozlabs.org ([203.10.76.45]:54119 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1KHG0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:26:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] module: Fix performance regression on modules with large symbol tables
In-Reply-To: <CAJiQ=7D4SSzzkPpPMGnaTq-wZXUGmXCRfKhYdPFg7APDu+VTwA@mail.gmail.com>
References: <467be983bed865e1b772136ed488f9ff@localhost> <874nygu3cd.fsf@rustcorp.com.au> <CAJiQ=7D4SSzzkPpPMGnaTq-wZXUGmXCRfKhYdPFg7APDu+VTwA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 08 Nov 2011 09:57:32 +1030
Message-ID: <87d3d3secb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011 11:58:08 -0800, Kevin Cernekee <cernekee@gmail.com> wrote:
> > I've started a separate patch to add comments to all this.
> 
> Not sure how you want to handle combining these changes?
> 
> I'll just send a V2 that rolls in all of the desired modifications, if
> there are no objections...

Please do.  I'll write a comment patch on top of that, too.

Thanks!
Rusty.
