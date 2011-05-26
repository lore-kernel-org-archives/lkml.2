Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1EZIUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:20:13 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:55957 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab1EZIUL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:20:11 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>
CC: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>, Xiangliang Yu <yuxiangl@marvell.com>
Date: Thu, 26 May 2011 01:16:26 -0700
Subject: RE: [PATCH 2/2] mvsas: add support for Task collector mode and
 fixed relative bugs
Thread-Topic: [PATCH 2/2] mvsas: add support for Task collector mode and
 fixed relative bugs
Thread-Index: AcwbHCzUY4mgNiPIRoGMhauiaaMmcwAWPO4g
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD846B5@SC-VEXCH4.marvell.com>
References: <mvsas-support-task-collector-mode>
	<1303825011-6345-1-git-send-email-yxlraid@gmail.com>
 <BANLkTi=xZnK6--p0gp+MAH1aRRJsPw9=Lg@mail.gmail.com>
In-Reply-To: <BANLkTi=xZnK6--p0gp+MAH1aRRJsPw9=Lg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Xiangliang Yu <yuxiangl@marvell.com>
>>
>> 3.Unlock ap->lock within .lldd_execute_task for direct mode to improve performance

>Can you share more details about the performance impact?  Seems like
>this should be made generic across all libsas drivers... see below.

The direct mode should be change to task collector mode. Sorry, this is my fault.
We can use interrupt tasklet by unlocking ap->lock within .lldd_execute_task,
but interrupt tasklet has some issue, and I'm debugging it.


