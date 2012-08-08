Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2HHLgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:36:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58091 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2HHLgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:36:10 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-d6-50224f299a06
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, patches@linaro.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
 <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
 <5020F568.5020204@linaro.org>
 <0a2d01cd7500$53e26c50$fba744f0$%kim@samsung.com>
 <20120808061102.GA22417@avionic-0098.mockup.avionic-design.de>
 <0abe01cd752f$4f96ad80$eec40880$%kim@samsung.com>
 <20120808065046.GA30832@avionic-0098.mockup.avionic-design.de>
 <0af001cd7550$1af66040$50e320c0$%kim@samsung.com>
 <20120808110713.GC20296@avionic-0098.mockup.avionic-design.de>
In-reply-to: <20120808110713.GC20296@avionic-0098.mockup.avionic-design.de>
Subject: RE: [PATCH] ARM: SAMSUNG: Fix compilation error with s3c2410_defconfig
Date: Wed, 08 Aug 2012 20:36:08 +0900
Message-id: <0b1301cd755a$011e1eb0$035a5c10$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11Vf4j+RgMDoUzTsm5fHl8VNA9oAAAoL5Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQV1Nf6UAg67T7BaXd81hs5hxfh+T
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmPXrWzFazkqPi2/jZ7A+Nxti5GTg4JAROJ7kfNrBC2
	mMSFe+uB4lwcQgLTGSWmNs9mhHD+Mkr8WvmGEaSKTUBD4vD7Z+wgtoiAucSSRXuZQYqYBQ4z
	StyYOoUJJCEk8JtZYslkORCbU8Bbou37YqAiDg5hAX+JR50FIGEWAVWJqc9vM4GEeQVsJb7P
	AqvmFRCU+DH5HguIzSygJbF+53EmCFteYvOat2BTJATUJR791YW4wEii7c9idogSEYl9L94x
	TmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEB/UxqB+PK
	BotDjAIcjEo8vFHJigFCrIllxZW5hxglOJiVRHj7XZUChHhTEiurUovy44tKc1KLDzFKc7Ao
	ifMae3/1FxJITyxJzU5NLUgtgskycXBKNTDaTuvkWLK7e7n5OwHZtN7i6pqAUwtt9t8sn90r
	zfPqTGvAv/lpHC7hvsyq7J9vCMfknbX4u9B9cZA2Q14Tm5ej6NO6rTXshxlfyfy+FeAr8Tgo
	+eLHeyt/+3E4ab47p3jti53FBdGGy9nJfz4KfZexzqz91rr62zvezGfMSvk/XgbHmaavEFJi
	Kc5INNRiLipOBAAYbHoPZAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry Reding wrote:
> 
> On Wed, Aug 08, 2012 at 07:25:17PM +0900, Kukjin Kim wrote:
> > Thierry Reding wrote:
> > >
> > > On Wed, Aug 08, 2012 at 03:30:32PM +0900, Kukjin Kim wrote:
> >

[...]

> He (she?) sent two patches:
> 
He :-)

> 	https://lkml.org/lkml/2012/8/2/108
> 	https://lkml.org/lkml/2012/8/2/109
> 
> And followed-up with the following three:
> 
> 	https://lkml.org/lkml/2012/8/3/47
> 	https://lkml.org/lkml/2012/8/3/44
> 	https://lkml.org/lkml/2012/8/3/45
> 
Thanks for above list-up and if any comments, let you know.

[...]


> Yes, that looks good to me. Do you want me to take that through the PWM
> tree or would you rather take it through yours?
> 
Thanks. Since the error happens in arch/arm/ part and this patch touches
some arch/arm/ files, would be better if this could be sent to upstream via
samsung tree. Of course, if your ack, would be nice to me ;-)

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

