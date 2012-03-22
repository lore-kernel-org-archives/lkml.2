Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2CVEFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 00:05:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37925 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2CVEFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 00:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAK2p4sJ4LJGJ6moqrZ9En6SLRsw0k6EbWqJ19dUzN9BRvsz39g@mail.gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com> <CAK2p4sJ4LJGJ6moqrZ9En6SLRsw0k6EbWqJ19dUzN9BRvsz39g@mail.gmail.com>
From: Santosh Y <santoshsy@gmail.com>
Date: Thu, 22 Mar 2012 09:34:50 +0530
Message-ID: <CALMYJDuHUhybFtw1Bn-K7jP_zv1UzS5XTwteuqCzaCXZCfBpSQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] [SCSI] ufshcd: UFS Host Controller Driver
To: Deepak Saxena <dsaxena@linaro.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        yejin.moon@samsung.com, ilho215.lee@samsung.com, nala.la@samsung.com,
        stephen.doel@linaro.org, sreekumar.c@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 7:17 AM, Deepak Saxena <dsaxena@linaro.org> wrote:
> On 23 February 2012 23:19, Santosh Y <santoshsy@gmail.com> wrote:
>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>
>> UFS:
>> Universal Flash Storage is a storage specification for flash devices.
>> It is aimed to provide a universal storage interface for both
>> embedded and removable flash memory based storage in mobile
>> devices such as smart phones and tablet computers. The specification
>> is defined by JEDEC Solid State Technology Association. UFS is based
>> on MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
>> physical layer and MIPI Unipro as the link layer.
>
> Hi Santosh, James et all,
>
> I've not seen many comments on these patches. It looks like just a few minor
> issues that may need to be resolved. It's probably too late to get this into
> 3.4, but could we get this pulled into scsi tree's for linux-next  branch once
> these issue are resolved? Santosh, do you have a new version of the patches
> to post with these updates?
>
> Thanks,
> ~Deepak

Hi Deepak,

UFSHCD v3 patches incorporate the changes for the comments received on
v2 patches and were posted on Feb 29th, 2012.

Regards,
Santosh
