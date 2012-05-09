Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab2EIP17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:27:59 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:25966 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947Ab2EIP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:27:58 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ingo Molnar <mingo@kernel.org>, Ido Yariv <ido@wizery.com>
CC: "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 9 May 2012 11:27:40 -0400
Subject: RE: [tip:x86/platform] vsmp: Fix number of CPUs when vsmp is
 disabled
Thread-Topic: [tip:x86/platform] vsmp: Fix number of CPUs when vsmp is
 disabled
Thread-Index: Ac0tw9n3yBDQ5YE5RtOgGOcezfrqdAAK8VSQ
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317D0A62A2AF@VMBX108.ihostexchange.net>
References: <1336462455-22544-1-git-send-email-ido@wizery.com>
 <tip-824a6ae65f085255464155760cb9628a2f0deb29@git.kernel.org>
 <20120508122548.GA5741@gmail.com>
 <20120509080335.GA5556@NoteStation.colubris.lan>
 <20120509091212.GA8585@gmail.com>
In-Reply-To: <20120509091212.GA8585@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q49FS963003805

Ingo Molnar wrote:
> Well, then fix the Makefile rule as well. Is there any point to
> using vSMP specific glue on UP kernels?

Yes - vsmp_64.c is needed even on UP kernel. 
This allows single CPU kernels, running on vSMP Foundation (such as installer kernels), to make use of the other virtualization-specific (under CONFIG_PARAVIRT )codes such as set_vsmp_pv_ops().

... thinking about it, I do not see other way to resolve this rather than Ido's suggestion.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
