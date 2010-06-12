Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0FLTfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 15:35:18 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:34295 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752128Ab0FLTfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 15:35:16 -0400
X-DYX-POP3-Checked-Auth: 114.32.100.136:kernel@takeo.idv.tw
Message-ID: <CF019A593DE0459AA76B9B3655FBF473@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
       <viro@zeniv.linux.org.uk>, <sfr@canb.auug.org.au>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1> <4C129778.7040409@suse.cz> <F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1> <20100612094937.GA12455@lst.de>
In-Reply-To: <20100612094937.GA12455@lst.de>
Subject: Re: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: Permission denied
Date: Sun, 13 Jun 2010 03:35:15 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was try this patch, seems all is normal now. thanks for your patch.

Best Regards,
Takeo Tung

--------------------------------------------------
From: "Christoph Hellwig" <hch@lst.de>
Sent: Saturday, June 12, 2010 5:49 PM
To: "Takeo Tung" <kernel@takeo.idv.tw>
Cc: "Michal Marek" <mmarek@suse.cz>; <linux-kernel@vger.kernel.org>; 
<viro@zeniv.linux.org.uk>; <sfr@canb.auug.org.au>
Subject: Re: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: 
Permission denied

> Please try the patch below, looks like I did a horrible messup in the
> last version of the patch:
>
>
> Index: linux-2.6/fs/attr.c
> ===================================================================
> --- linux-2.6.orig/fs/attr.c 2010-06-12 11:45:50.458003839 +0200
> +++ linux-2.6/fs/attr.c 2010-06-12 11:45:59.103005305 +0200
> @@ -34,7 +34,7 @@ int inode_change_ok(const struct inode *
>  * First check size constraints.  These can't be overriden using
>  * ATTR_FORCE.
>  */
> - if (attr->ia_mode & ATTR_SIZE) {
> + if (ia_valid & ATTR_SIZE) {
>  int error = inode_newsize_ok(inode, attr->ia_size);
>  if (error)
>  return error;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> 
