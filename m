Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab2GCULl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:11:41 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:36106 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424Ab2GCULk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:11:40 -0400
Message-ID: <4FF351F8.1000003@msgid.tls.msk.ru>
Date: Wed, 04 Jul 2012 00:11:36 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com> <20120703090441.GA4804@gmail.com>
In-Reply-To: <20120703090441.GA4804@gmail.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.07.2012 13:04, Zheng Liu wrote:
> Hi Jeff,
> 
> Sorry for bothering you.  Could you please review this patch, or give me
> some feedbacks.  If this patch can be applied, I can rebase it to the
> lastest version of mainline kernel.  Thank you.
[]
>> -int libata_fua = 0;
>> +int libata_fua = 1;

I guess it can be enabled after LOTS of testing of various drives out
there, which shows that no current drives have issues with FUA anymore,
and after building a black-list of devices which misbehave.  It is quite
a big project, I think.  But what it gives us in return?

(I've no idea if this is the right answer, speaking of myself only)

Thanks,

/mjt
