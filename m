Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2GLXqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:46:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55215 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759494Ab2GLXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:45:56 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-a8-4fff61b38deb
Message-id: <4FFF61B2.7010107@samsung.com>
Date: Fri, 13 Jul 2012 08:45:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Remove CONFIG_EXTCON_MODULE config to fix build
 break
References: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
 <20120712153626.GD17365@kroah.com>
In-reply-to: <20120712153626.GD17365@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd3Nif/9Deav4ba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZHy5NYio4wV7xv+khYwNjM1sXIyeHhICJxNHGjVC2mMSFe+uB
	bC4OIYHpjBK/by9mAUkICXQxSXxYxQ9i8wpoSSy895QVxGYRUJU4fmQlmM0GFN//4gZQMweH
	qECExK9+DohyQYkfk++BjRER0JB4efQWmM0sMJVR4tiPbBBbWCBE4vnnGcwgrUICmRILd4iD
	hDkF9CWOHrsPVa4jsb91GhuELS+xec1b5gmMArOQbJiFpGwWkrIFjMyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYKD75nUDsaVDRaHGAU4GJV4eBdE//cXYk0sK67MPcQowcGsJMK7zh4o
	xJuSWFmVWpQfX1Sak1p8iFGag0VJnNfY+6u/kEB6YklqdmpqQWoRTJaJg1OqgbE0P/Ccc8yK
	q+8TbaynPPty7Ivu10eblhcqiWTXHJ8yf5O/x/SpD5QypjDo7D25m6ngYtXK8MVyv04lNx7i
	ufnywVYX7c667N0nZHmrp2Re3uZ3/lPmrpVVfNtkjbnM3pu9ijTfFcF1dHfKfz9ZwzM8Xj0r
	L024lCsefmhCkgH/l4cMYgfDlV4osRRnJBpqMRcVJwIAntymXToCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 07/13/2012 12:36 AM, Greg KH wrote:

> On Thu, Jul 12, 2012 at 01:32:27PM +0900, Chanwoo Choi wrote:
>> This patch modify 'Kconfig' of EXTCON Subsystem to support either
>> active or inactive of EXTCON Subsystem. The various subsystem refer
>> to EXTCON subsystem for controlling external connector, so core class
>> of EXTCON should be included in kernel image. If EXTCON subsystem is
>> builded with MODULE, other subsystem have build break because of
>> linking the core class of EXTCON.
> 
> Then something else is wrong, as the extcon_class code should be able to
> be built as a module.  Don't load up systems with kernel code that they
> don't need (think of distro kernels that have to build everything.)
> 
> So no, please fix the real problem here, I will not take this patch,
> sorry.

OK, I will add appropriate dependency to 'Kconfig' of subsystem/driver
using EXTCON
to resolve build break.

Thank you,
Chanwoo Choi
