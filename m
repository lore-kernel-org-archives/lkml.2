Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab2DZWcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:32:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:32:43 -0400
Date: Thu, 26 Apr 2012 15:32:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/4] bug: completely remove code of disabled VM_BUG_ON()
Message-Id: <20120426153241.6d4762a2.akpm@linux-foundation.org>
In-Reply-To: <CAMuHMdW7eQh8eaNZrwRHqduPYCjNXv+LriZoH6-ERdkHH2qL8g@mail.gmail.com>
References: <20120425112623.26927.43229.stgit@zurg>
	<20120425112629.26927.21609.stgit@zurg>
	<CAMuHMdW7eQh8eaNZrwRHqduPYCjNXv+LriZoH6-ERdkHH2qL8g@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 16:40:32 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Wed, Apr 25, 2012 at 13:26, Konstantin Khlebnikov
> <khlebnikov@openvz.org> wrote:
> > Even if CONFIG_DEBUG_VM=n gcc genereates code for some VM_BUG_ON()
> 
> That's because of the side effects of the expression
> 
> https://lkml.org/lkml/2012/4/25/146
> 
> But IRIC, we do want them here?
> 

AFAICT (lkml.org appears to be having a meltdown), you've gone and
linked to this very thread.

Please try again, this time avoiding hyperlinks ;)
