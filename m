Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1K3O6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:58:13 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45851 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1K3O6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:58:12 -0500
Date: Wed, 30 Nov 2011 15:57:42 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg KH <gregkh@suse.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio: make phys maps optionally cacheable
Message-ID: <20111130145742.GC15616@local>
References: <1322619165-4330-1-git-send-email-jeff.dagenais@gmail.com>
 <20111130114310.GC15275@local>
 <0A290EA2-D5E1-489B-8B3D-3C8B79826C38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0A290EA2-D5E1-489B-8B3D-3C8B79826C38@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 09:11:31AM -0500, Jean-Francois Dagenais wrote:

[...]
> > 
> > OK, but I won't accept a change to the UIO core without an in-kernel user.
> > Please post a driver that actually needs this. This was already discussed
> > four weeks ago, see here: https://lkml.org/lkml/2011/10/28/247
> Well, my employer is paying for my time to get our product working, not to maintain
> the kernel. I have succeeded in arguing that the the changes I make to the kernel in
> order to make our branch of the kernel work could benefit everyone, and when the
> kernel get better, it's more adopted, then more support comes, bla bla... right.

The embedded Linux nightmare... More arguments here:

http://lwn.net/Articles/232379/

[...]
>  Everyone wins if you apply Kumar's patch.

It won't be applied without an in-kernel user. Same story.

Thanks,
Hans
