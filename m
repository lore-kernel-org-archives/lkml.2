Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340Ab0HMDoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:44:32 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:15090 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0HMDoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:44:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
Date: Thu, 12 Aug 2010 20:44:16 -0700
Message-ID: <8A71B368A89016469F72CD08050AD33408403F41@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
Thread-Index: Acs6lqd0Is4ZuYSYQSOfuS0rBWQa2wAAxdDA
References: <201008130257.o7D2vLVx001282@localhost.localdomain> <1281669700.15486.71.camel@Joe-Laptop>
From: "Karen Xie" <kxie@chelsio.com>
To: "Joe Perches" <joe@perches.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <open-iscsi@googlegroups.com>, "Rakesh Ranjan" <rakesh@chelsio.com>,
        <James.Bottomley@HansenPartnership.com>, <michaelc@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7D3ik34015118

Thanks,

Will use pr_xxx instead.

Karen

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com] 
Sent: Thursday, August 12, 2010 8:22 PM
To: Karen Xie
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; open-iscsi@googlegroups.com; Rakesh Ranjan; James.Bottomley@HansenPartnership.com; michaelc@cs.wisc.edu
Subject: Re: [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i

On Thu, 2010-08-12 at 19:57 -0700, kxie@chelsio.com wrote:
> [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
[]
> +#define libcxgbi_log_error	cxgbi_dbg_error
> +#define libcxgbi_log_warn	cxgbi_dbg_warn
> +#define libcxgbi_log_info	cxgbi_dbg_info
> +#define libcxgbi_log_debug(flag, fmt, args...) \
> +	cxgbi_dbg_print(flag, fmt, ## args)

I think this double indirection isn't useful and it would
be simpler/better to use pr_<level>

[]

> +#define cxgbi_dbg_print(level, fmt, args...)	\
> +	do {	\
> +		if (dbg_level & (level)) \
> +			printk(KERN_INFO "cxgbi: %s - " fmt, \
> +				__func__ , ## args); \
> +	} while (0)
> +#define	cxgbi_dbg_error(fmt, args...) \
> +	printk(KERN_ERR "cxgbi: ERR! %s, " fmt, __func__ , ## args)
> +#define cxgbi_dbg_warn(fmt, args...) \
> +	printk(KERN_WARNING "cxgbi: WARN! %s, " fmt, __func__ , ## args)
> +#define cxgbi_dbg_info(fmt, args...) \
> +	printk(KERN_INFO "cxgbi: %s, " fmt, __func__ , ## args)


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
