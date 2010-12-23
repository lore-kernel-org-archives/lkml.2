Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0LWBkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:40:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34697 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0LWBkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ezZLTVGI1UBRSZ+kToXFRHWOQ0Jk61GEFqFeCrWCrb2fKndL0yJ0w2cvgrPT+liiEl
         nJ/x0SnztBUdnAWBjoyohlNvzlGFs543CFUdNh5B0vOhiOfG/jC0i9Pi/IPlw1xPS8Xp
         sp3Gb7Rcr8V4COTbEjPnf1bZSpfalhT6ws2aY=
MIME-Version: 1.0
In-Reply-To: <20101222132235.GA26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
	<1292998991-26968-2-git-send-email-myungjoo.ham@samsung.com>
	<20101222132235.GA26306@opensource.wolfsonmicro.com>
Date: Thu, 23 Dec 2010 10:40:04 +0900
X-Google-Sender-Auth: uUcm3EKuBgYc0hckJb8BFGJWz_M
Message-ID: <AANLkTik8T=wmKcV13hLSkGsum3pDoPBsJ=fQZwhLA1PR@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] MFD MAX8998/LP3974: Support Hibernation
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:22 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 22, 2010 at 03:23:06PM +0900, MyungJoo Ham wrote:
>> With runtime-pm ops support, this patch enables to save and restore
>> register values for hibernation.
>
> There's no actual runtime PM support in this patch, but this looks like
> it's just an error in the changelog?
>

Probably, it can be rephrased as "Providing struct dev_pm_ops, this
patch enables to save and restore register values for hibernation".
Anyway, implementing such features also resulted in proper behavior
with runtime-pm enabled kernel. (Before this patch, there were issues
with sleep-wakeup with lp3974 irqs if runtime-pm is enabled)


-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
