Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2ECUcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:32:08 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:44899 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2ECUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:32:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowFAMLqok9bdWOb/2dsb2JhbABFgx6sA4NbgQeCCQEBBXkQCxgJJQ8CRgYNAQcCiA26cpEIBJV+kEKCag
X-IronPort-AV: E=Sophos;i="4.75,527,1330902000"; 
   d="scan'208";a="984800212"
Message-ID: <4FA2EC70.30809@igalia.com>
Date: Thu, 03 May 2012 22:37:04 +0200
From: =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] staging: sm7xx: code improvements and cleanup
References: <20120425205532.GA9642@kroah.com> <1335465955-32057-1-git-send-email-jmunhoz@igalia.com> <20120427074448.GG6447@mwanda>
In-Reply-To: <20120427074448.GG6447@mwanda>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 09:44 AM, Dan Carpenter wrote:
> On Thu, Apr 26, 2012 at 08:45:48PM +0200, Javier M. Mellid wrote:
>> This set of patches implement some code improvements, dead code removal
>> and cleanup. New code uses dynamic debug support.
>>
>> The patches address new checkpatch warnings.
>>
>> Patches tested with SM712.
>>
> 
> Thanks for breaking that up into separate patches.  Nicely done.

Thanks Dan!

Javier

