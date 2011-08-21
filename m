Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1HUDQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 23:16:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1HUDQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 23:16:02 -0400
Date: Sat, 20 Aug 2011 20:15:55 -0700
From: Greg KH <gregkh@suse.de>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] devtmpfs: Fix section mismatch warning
Message-ID: <20110821031555.GA25900@suse.de>
References: <1313894655-3783-1-git-send-email-harvey.huawei.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313894655-3783-1-git-send-email-harvey.huawei.yang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 10:44:15AM +0800, Harvey Yang wrote:
> drivers/base/built-in.o(.text+0xe554): Section mismatch in reference f
> rom the function devtmpfsd() to the variable .init.data:setup_done
> The function devtmpfsd() references
> the variable __initdata setup_done.
> This is often because devtmpfsd lacks a __initdata
> annotation or the annotation of setup_done is wrong.
> 
> "setup_done" is not used after init. but putting it into initdata section leads a section mismatch warning, so initialize it dynamically in __init function.
> 
> Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>

Already in linux-next, thanks, it will go to Linus next week.

greg k-h
