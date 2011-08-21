Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1HUEfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 00:35:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:33926 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1HUEfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 00:35:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wanlong Gao <wanlong.gao@gmail.com>
Subject: Re: [PATCH 1/1] devtmpfs: Fix section mismatch warning
Date: Sun, 21 Aug 2011 04:31:42 +0000 (UTC)
Message-ID: <loom.20110821T062947-467@post.gmane.org>
References: <1313894655-3783-1-git-send-email-harvey.huawei.yang@gmail.com> <20110821031555.GA25900@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 112.80.209.86 (Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.825.0 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh <at> suse.de> writes:

> 
> On Sun, Aug 21, 2011 at 10:44:15AM +0800, Harvey Yang wrote:
> > drivers/base/built-in.o(.text+0xe554): Section mismatch in reference f
> > rom the function devtmpfsd() to the variable .init.data:setup_done
> > The function devtmpfsd() references
> > the variable __initdata setup_done.
> > This is often because devtmpfsd lacks a __initdata
> > annotation or the annotation of setup_done is wrong.
> > 
> > "setup_done" is not used after init. but putting it into initdata section 
leads a section mismatch
> warning, so initialize it dynamically in __init function.
> > 
> > Signed-off-by: Harvey Yang <harvey.huawei.yang <at> gmail.com>
> 
> Already in linux-next, thanks, it will go to Linus next week.
> 
> greg k-h
> 
Greg has already committed a simple patch.
Plz see:
http://git.kernel.org/?p=linux/kernel/git/next/linux-
next.git;a=commitdiff;h=f9e0b159dbff693bacb64a929e04f442df985b50

Thanks
-Wanlong Gao

