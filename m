Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1GACDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:03:42 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49258 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab1GACDl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:03:41 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Dan Williams <dan.j.williams@intel.com>,
        "yxlraid@gmail.com" <yxlraid@gmail.com>
CC: "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "jack_wang@usish.com" <jack_wang@usish.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Thu, 30 Jun 2011 19:03:27 -0700
Subject: RE: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
Thread-Topic: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
Thread-Index: Acw3TanwceDS/4dlTKOvJaKpKOcw3QAQle2w
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAF50016@SC-VEXCH4.marvell.com>
References: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
 <BANLkTinDLpb=mQpBEF3JnaA4eXrZC14aYA@mail.gmail.com>
In-Reply-To: <BANLkTinDLpb=mQpBEF3JnaA4eXrZC14aYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Subject: Re: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet

>On Thu, Jun 30, 2011 at 7:27 AM,  <yxlraid@gmail.com> wrote:
>> From: Xiangliang Yu <yuxiangl@marvell.com>
>>
>> -- Add support for interrupt tasklet, which will improve performance.

>Interesting, do you happen to have comparative performance numbers?
According to internal test, the increase of tasklet performance is about
1.5MB. This is first step, I will continue to enhance the performance.

>>
>>  ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
>> +ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) := -DMVS_USE_TASKLET

>Question, why not just use "#ifdef CONFIG_SCSI_MVSAS_TASKLET" and drop
>these redefinitions?
I think the Tasklet is a experimental feature, if any problem, the user
Can close the feature. 

Thanks!

