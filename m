Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2GEId2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:33:28 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43409 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab2GEIdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:33:19 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "Finnbarr P. Murphy" <fpm@fpmurphy.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: UEFI Secure Boot
Thread-Topic: UEFI Secure Boot
Thread-Index: AQHNWgWUgCEURf5RdUChyaGvNxEu3Jca0vIA
Date: Thu, 5 Jul 2012 08:33:17 +0000
Message-ID: <1341477196.3121.11.camel@dabdike>
References: <4FF474E4.2030402@fpmurphy.com>
In-Reply-To: <4FF474E4.2030402@fpmurphy.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [195.214.232.10]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6138F78EEF3BF409C45A2D08866C989@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q658XZMB027302

[added mailing list cc's since this is probably going to be a common question]

On Wed, 2012-07-04 at 12:52 -0400, Finnbarr P. Murphy wrote:
> Hi James,
> 
> Nice work on your UEFI Secure Boot demo code!
> 
> Have you experimented with either of the following scenarios?
> 
>     - Removing current PK via a utility
>     - Replacing current PK with a new PK via a utility
> 
> assuming you know existing PK keys.

Not yet ... I'm still working on writing the code that constructs the
time based authentication bundle for the variables.  When I have it, it
will appear in my git repository (and I'll probably send a note to the
linux-efi list):

http://git.kernel.org/?p=linux/kernel/git/jejb/efitools.git;a=summary

>  From Chapter 27 of the UEFI Specification, this should be possible but 
> I cannot get either scenarios to work (due to error 26 - Security 
> Violation)   Perhaps it is the OVMF implementation (latest from trunk) 
> but I suspect it is just my old age!

Constructing time based authentication bundles is complex ... are you
sure you have the code right?  error 26 means the platform doesn't think
the authentication is correct.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
