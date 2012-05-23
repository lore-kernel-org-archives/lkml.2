Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2EWADb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:03:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15643 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2EWADa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:03:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fe76d0000023f5-92-4fbc2950796d
Message-id: <4FBC2950.5090304@samsung.com>
Date: Wed, 23 May 2012 09:03:28 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Gridwodd <lrg@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH v4 1/3] mfd: MAX77686: Add Maxim 77686 mfd driver
References: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337593907-6615-2-git-send-email-jonghwa3.lee@samsung.com>
 <20120522215743.GF10210@sortiz-mobl>
In-reply-to: <20120522215743.GF10210@sortiz-mobl>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAd0AzT3+Br/vSVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mw5//MBX8Yal49fotewPjR+YuRk4OCQETiX2HdrBA2GISF+6t
	Z+ti5OIQEljEKPFnwxuwBK+AoMSPyfeAbA4OZgF5iSOXskHCzALqEpPmLWKGqO9jkvjw5gMj
	RL2WRMeCqUwgNouAqkTTo2+sIDabgJzE26ZvjCBzRAUiJH71c4CYIgIaEnt7akDGMAscZpJo
	vTUV7DZhAVeJh7++g9lCAmsYJZ5cjwexOQUMJa62/GWdwCgwC8l1sxCum4XkugWMzKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgoPvmdQOxpUNFocYBTgYlXh4b9zf7S/EmlhWXJl7iFGC
	g1lJhHf9dKAQb0piZVVqUX58UWlOavEhRmkOFiVxXrvFO/yFBNITS1KzU1MLUotgskwcnFIN
	jEGMQonHHs2ar3HzksnqGLNYFxdmoTMau47uPC2WrpvPnelVs5G/4ieXjbW2kPjG9pw3v38/
	TA9rcVn4flPxJo17522OVli+PznFvU51T8mVCRt8Vjtd/549q77nce/Jj/vCLWatzD1mfn5z
	n6w9M2PnjWu5oc8Vuw5usuU7XfPqotMFFbebskosxRmJhlrMRcWJACx41Nc6AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 05월 23일 06:57, Samuel Ortiz wrote:

> Hi Jongwha,
> 
> On Mon, May 21, 2012 at 06:51:45PM +0900, Jonghwa Lee wrote:
>> This patch is device driver for MAX77686 chip.
>> MAX77686 is PMIC and includes regulator and rtc on it.
>> This driver is core of MAX77686 chip, so provides common support for accessing
>> on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
>> to its register with i2c bus.
> I'll try to push this one after rc1, or as a late merge window pull request.
> 
> Cheers,
> Samuel.
> 

Hi, Samuel,
Thanks for your quick confirmation.

Best regards.
Jonghwa.
