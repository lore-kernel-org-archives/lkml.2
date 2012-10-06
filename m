Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2JFSMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:12:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62965 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2JFSMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:12:40 -0400
Message-ID: <1349547151.12699.41.camel@kjgkr>
Subject: Re: [PATCH 13/16] f2fs: add xattr and acl functionalities
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sun, 07 Oct 2012 03:12:31 +0900
In-Reply-To: <87a9w0slpy.fsf@xmission.com>
References: <001401cda2f1$8f16b320$ad441960$%kim@samsung.com>
	 <87a9w0slpy.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-05 (금), 13:33 -0700, Eric W. Biederman:
> 김재극 <jaegeuk.kim@samsung.com> writes:
> 
> > This implements xattr and acl functionalities.
> >
> > - F2FS uses a node page to contain use extended attributes.
> 
> Please note the arguments to posix_acl_to_xattr and posix_acl_from_xattr
> have changed, which will cause this patch to fail to compile.
> 

I missed some recent patches related to this.
I'll check and apply them.
Thanks,

> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

