Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1ANWP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:15:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:56559 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab1ANWP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:15:56 -0500
Date: Fri, 14 Jan 2011 12:04:26 -0800
From: Greg KH <gregkh@suse.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Build failure: smbfs
Message-ID: <20110114200426.GA16345@suse.de>
References: <AANLkTi=4AeqYHR6LS8MzaZ42raMrkTvE2H4pUgGzNvBo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=4AeqYHR6LS8MzaZ42raMrkTvE2H4pUgGzNvBo@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 09:39:47PM +0200, Anca Emanuel wrote:
>   CC [M]  drivers/staging/smbfs/dir.o
>   CC [M]  drivers/usb/atm/speedtch.o
> drivers/staging/smbfs/dir.c:286: error: static declaration of
> ‘smbfs_dentry_operations’ follows non-static declaration
> drivers/staging/smbfs/proto.h:42: note: previous declaration of
> ‘smbfs_dentry_operations’ was here
> drivers/staging/smbfs/dir.c:294: error: static declaration of
> ‘smbfs_dentry_operations_case’ follows non-static declaration
> drivers/staging/smbfs/proto.h:41: note: previous declaration of
> ‘smbfs_dentry_operations_case’ was here
> make[4]: *** [drivers/staging/smbfs/dir.o] Error 1
> make[3]: *** [drivers/staging/smbfs] Error 2
> make[2]: *** [drivers/staging] Error 2

Patch was just posted to lkml for this.

thanks,

greg k-h
