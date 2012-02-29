Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759Ab2B2SI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:08:57 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2726 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757642Ab2B2SIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:08:55 -0500
X-SpamScore: -7
X-BigFish: VS-7(zz9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Thread-Topic: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Thread-Index: AQHM9w0vzneIpsOv1Eu0atBxXWRJcA==
Date: Wed, 29 Feb 2012 18:08:49 +0000
Message-ID: <CAOZdJXV69jbbDbJKrLevLxe-2Qqz1wd-g6mBDwecL=r1jJ1jcA@mail.gmail.com>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
	<CAM=Q2ctLm8FKgTek6u9H0jzWJv1bbBUnvDHZfEA=p2ReK8ybUQ@mail.gmail.com>
In-Reply-To: <CAM=Q2ctLm8FKgTek6u9H0jzWJv1bbBUnvDHZfEA=p2ReK8ybUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mr.google.com; spf=pass (google.com: domain of
 b04825@freescale.com designates 10.14.127.76 as permitted sender)
 smtp.mail=b04825@freescale.com
x-originating-ip: [107.22.165.113]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C0A110029EFA914C977DA269C71F0EE8@mgd.freescale.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 7:02 AM, Shubhrajyoti Datta
<omaplinuxkernel@gmail.com> wrote:
>
>> +#ifdef CONFIG_PM
>> +       u8 fdr, dfsrr;

> How about having  a structure here ?

Why? He's just adding two variables in an existing structure.  Adding
a nested structure would unnecessarily complicate things.

-- 
Timur Tabi
Linux kernel developer at Freescale
