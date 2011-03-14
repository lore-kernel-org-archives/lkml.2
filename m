Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1CNFPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 01:15:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1CNFPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 01:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vGsrnJyrU1Prw0vPlOUb2x+KhEDbKVgfwlYD6mNPmjN8a6WwVk4D0IJ/oUQPm4JXF4
         tkkYUUc79CRGgx6BRzeqPR7rNK/bQ9m1cB7T34UTALNGn0gESf9oiTPe+H0LuUOWwzxN
         9MrQjzgULESjLoXCHcwxOxfqQ4kRJe7OEKttU=
MIME-Version: 1.0
In-Reply-To: <20110311120010.GC1760@opensource.wolfsonmicro.com>
References: <1299810886-19684-1-git-send-email-myungjoo.ham@samsung.com>
	<1299810886-19684-3-git-send-email-myungjoo.ham@samsung.com>
	<20110311120010.GC1760@opensource.wolfsonmicro.com>
Date: Mon, 14 Mar 2011 14:15:13 +0900
X-Google-Sender-Auth: Toms-wowiPLBexm8nRFtrANgTtk
Message-ID: <AANLkTind=ew1paSLVkp7w2uqCDCb7AZnc0MyQ3Snwk7P@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] MAX8997/8966 PMIC Regulator Driver Initial Release
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 9:00 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 11, 2011 at 11:34:44AM +0900, MyungJoo Ham wrote:
>> This patch supports PMIC/Regulator part of MAX8997/MAX8966 MFD.
>> In this initial release, selecting voltages or current-limit
>> and switching on/off the regulators are supported.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> though I do still think that voltage range information might make the
> side effect handling more useful.
>

Thank you.

The range information is partially used in choosing the voltage
although it does not remember the range information of other
previously-set regulators. I will try to let the driver hold the range
information of the regulators affected by GPIO-DVS set or consider
trying to put such features in the regulator core later.

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
