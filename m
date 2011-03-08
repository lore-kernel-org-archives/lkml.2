Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1CHFJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:09:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:49889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1CHFJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:09:38 -0500
Date: Mon, 7 Mar 2011 21:04:25 -0800
From: Greg KH <gregkh@suse.de>
To: wwang <wei_wang@realsil.com.cn>
Cc: Dan Carpenter <error27@gmail.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rts_pstor: MSXC card power class
Message-ID: <20110308050425.GA12135@suse.de>
References: <1299485461-3941-1-git-send-email-wei_wang@realsil.com.cn>
 <20110307185001.GX3416@bicker>
 <4D75971F.9050802@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D75971F.9050802@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:40:31AM +0800, wwang wrote:
> 于 2011年03月08日 02:50, Dan Carpenter 写道:
> >
> > This makes scripts/checkpatch.pl complain.
> >
> > regards,
> > dan carpenter
> >
> Yes, it would produce a braces warning.
> Should I send another patch to fix it, or just resend the patch?

Resend, I've already dropped this one.

thanks,

greg k-h
