Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0EAQnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 12:43:33 -0400
Received: from kroah.org ([198.145.64.141]:38626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0EAQnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 12:43:32 -0400
Date: Fri, 30 Apr 2010 14:50:58 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Added new hv_utils driver to hyper-v -
	RE-CREATED
Message-ID: <20100430215058.GA11992@kroah.com>
References: <8AFC7968D54FB448A30D8F38F259C5621AFEC8AD@TK5EX14MBXC114.redmond.corp.microsoft.com> <20100429191434.GH21799@kroah.com> <8AFC7968D54FB448A30D8F38F259C5621AFF0EC8@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5621AFF0EC8@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 04:52:34PM +0000, Hank Janssen wrote:
> 
> Greg,
> 
> As requested, here is the patch, it was created against a fresh
> clone of kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> of this morning using the origin/staging-next branch. It was created with
> the help of the git format-patch command.
> 
> But when I do a diff from this patch and the one I send earlier this
> Week, I do not see anything different in my patch.

Yup, and as such, it still does not apply :(

Are you sure you are really basing your code on the staging-next branch?
When I try to apply this, I get the following errors:
	patching file drivers/staging/hv/Channel.c
	Hunk #2 succeeded at 667 with fuzz 1.
	Hunk #3 succeeded at 723 with fuzz 2.
	Hunk #4 succeeded at 861 with fuzz 2.
	Hunk #5 succeeded at 936 with fuzz 2.
	patching file drivers/staging/hv/ChannelMgmt.c
	Hunk #1 FAILED at 22.
	Hunk #2 FAILED at 73.
	Hunk #4 FAILED at 264.
	Hunk #5 FAILED at 334.
	4 out of 5 hunks FAILED -- saving rejects to file drivers/staging/hv/ChannelMgmt.c.rej
	patching file drivers/staging/hv/Kconfig
	Hunk #1 succeeded at 29 with fuzz 2.
	patching file drivers/staging/hv/Makefile
	Hunk #1 FAILED at 2.
	1 out of 2 hunks FAILED -- saving rejects to file drivers/staging/hv/Makefile.rej
	patching file drivers/staging/hv/VmbusPacketFormat.h
	Hunk #1 succeeded at 22 with fuzz 1.
	patching file drivers/staging/hv/ext_utils.c
	patching file drivers/staging/hv/hyperv_utils.c
	patching file drivers/staging/hv/utils.h

Can you please try again?

thanks,

greg k-h
