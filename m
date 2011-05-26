Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab1EZJFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:05:43 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:57115 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753841Ab1EZJFm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:05:42 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Greg KH <greg@kroah.com>, Xiangliang Yu <yuxiangl@marvell.com>
CC: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Thu, 26 May 2011 02:00:21 -0700
Subject: RE: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Thread-Topic: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Thread-Index: AcwbcMKuYp1TgBIuQvy/qtL3cH+pfAAEBLew
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
In-Reply-To: <20110526021809.GA22496@kroah.com>
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


>Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >coalescing to device attributes in sysfs
>> 
>> -- Add support for driver version and interrupt coalescing device attributes.

>When you add a sysfs file, you must also add a Documentation/ABI file as
>well.  Please do that here.

These device attributes are sysft class properties for the scsi host, and the
sysfs files are within scsi host sysfs directory. so, do you think I need add a ABI file?  and , I can't find anything about scsi host sysfs file under directory
Documentation/ABI. Thanks!

