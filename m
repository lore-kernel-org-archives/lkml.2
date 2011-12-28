Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1L1Es0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 23:48:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36564 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1L1EsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 23:48:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7b95ae00000198b-d3-4efa9f96fbcd
Message-id: <4EFA9F90.8090204@samsung.com>
Date: Wed, 28 Dec 2011 13:48:16 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-pm@vger.kernel.org, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, cbouatmailru@gmail.com, pali.rohar@gmail.com,
        prakity@mavell.com, lars@metafoo.de, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] power: introduce Charger-Manager
References: <1324979269-2453-1-git-send-email-dg77.kim@samsung.com>
 <20111227105555.GG2870@opensource.wolfsonmicro.com>
In-reply-to: <20111227105555.GG2870@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011년 12월 27일 19:55, Mark Brown wrote:
> On Tue, Dec 27, 2011 at 06:47:47PM +0900, Donggeun Kim wrote:
> 
>> Changes for v3:
>>     - rename variables and functions
>>     - clean up code
>>     - add build dependency of RTC_CLASS and REGULATOR
> 
> Does it actually depend on REGULATOR?  It looks like it just uses get
> and enable which are stubbed out automatically by the API.
> 
If CONFIG_REGULATOR is not defined,
compile error occurs because charger-manager calls
'regulator_force_disable' function.

Thanks.
-Donggeun
