Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2HWE1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:27:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60808 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2HWE1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:27:39 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-20-5035b13425d3
Message-id: <5035B12F.8090105@samsung.com>
Date: Thu, 23 Aug 2012 13:27:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] charger-manager: Stop charging when charge cable is
 detached and code clean
References: <1343365285-3462-1-git-send-email-cw00.choi@samsung.com>
 <20120823031002.GA16674@lizard>
In-reply-to: <20120823031002.GA16674@lizard>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAV2TjaYBBgfaFCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG9GUb2ApuclXM//CcuYHxFEcXIyeHhICJxLWW2+wQtpjEhXvr
	2boYuTiEBBYxSnxbv58RwulikpjXN48JpIpXQEti351+NhCbRUBVYsOVJWA2G1B8/4sbQDYH
	h6hAhMSvfg6IckGJH5PvsYDYIgI6Ep9vNoEtYBboYZT4cnIDWK+wQJrEqrNXWUFsISD7V/MH
	ZhCbE6jhwtzbYDazgLrEpHmLoGx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHILPpHYwrmywOMQowMGoxMObEWsaIMSaWFZcmXuIUYKDWUmEN3we
	UIg3JbGyKrUoP76oNCe1+BCjNAeLkjgvf59hgJBAemJJanZqakFqEUyWiYNTqoFxnY5ER0rG
	QZ13lulqaw9PtVXWD2xaOK9v5pyQ6qD7X9fe0WQWFWCc0b9Hzef+15OvLysUrZq5e2/Sqegj
	71pnSKXuu/LYjbH2bGpM9pWYywzxLbbaGx+kXPnaPzflVovZL4f0yMkrjlj2Jfru4FdktfXp
	XND7LkGdMSNCMu38szvvVRbc5P+gxFKckWioxVxUnAgAEh6TeT0CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 12:10 PM, Anton Vorontsov wrote:

> On Fri, Jul 27, 2012 at 02:01:25PM +0900, Chanwoo Choi wrote:
>> This patchset fix bug related to stop charging when charger cable is
>> detached and check return value of regulator_enable/disable() function
>> to confirm correct operation of enabled or disabling regulator for
>> charging. Second patch is code clean which remove unnecessary variable
>> type.
>>
>> Chanwoo Choi (2):
>>   charger-manager: Disable regulator for charging when charger cable is
>>     detached
>>   charger-manager: Use replacement variable to check state of battery
>>
>>  drivers/power/charger-manager.c       |   21 ++++++++++++++++++---
>>  include/linux/power/charger-manager.h |    3 ---
>>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> Both applied, much thanks!
> 

Thanks for your reply and applied it.

I did send additional patchset which has 5 patch and also include below
patch list,
if you may confuse due to duplicate patch, so I inform to you about
duplicate patch.

Chanwoo Choi (2):
   charger-manager: Disable regulator for charging when charger cable is
     detached
   charger-manager: Use replacement variable to check state of battery

You can check additional patchset for charger-manager:
https://lkml.org/lkml/2012/8/21/68

Thanks and Best Regards,
Chanwoo Choi
