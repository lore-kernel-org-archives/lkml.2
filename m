Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1HCQWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:22:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1HCQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:22:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=EjizWwReX9a0rVuh1wbUK7cTfsyErf7KZI30IGhVRak7SJvy5aiQfvCms8zr21TzN
	MNNDRd8vJ7koyTBC6pWxg==
MIME-Version: 1.0
In-Reply-To: <20110730191206.GF5686@core.coreip.homeip.net>
References: <1311787695-28147-1-git-send-email-miletus@chromium.org>
	<20110730191206.GF5686@core.coreip.homeip.net>
Date: Wed, 3 Aug 2011 12:22:19 -0400
X-Google-Sender-Auth: 1JFVyJdsn1Vdyc0UcebTgaOeYx8
Message-ID: <CAPDwgkOpBg911PjoAb1ywv769nC63QDAJgUSES+3PmRsMENMHg@mail.gmail.com>
Subject: Re: [PATCH v2] Input: atmel_mxt_ts - Report pressure information from
 the driver
From: Yufeng Shen <miletus@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Chris Leech <christopher.leech@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        "Gong, Michael" <Michael.Gong@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sent this email due to linux-input@veger.kernel.org rejecting last
reply for containing HTML subpart

-----------------------------------------------------------------------------------------------------------------------------------------------

Hi Dmitry,

Currently the driver atmel_mxt_ts.c supports 3 different models of
atmel touch controller:

1. qt602240_ts
2. atmel_mxt_ts   (which is for mxt1386)
3. mXT224

Confirmed with atmel side that qt602240_ts is actually an alias for
mxt224, and mxt224
follows the same protocol guide with mxt1386, which means it will
report the pressure
information the same way as mxt1386.

--- Yufeng Shen

On Sat, Jul 30, 2011 at 3:12 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Yufeng,
>
> On Wed, Jul 27, 2011 at 01:28:15PM -0400, Yufeng Shen wrote:
>> Atmel mxt1386 touch controller has the touch pressure information but
>> the current driver atmel_mxt_ts does not expose it to the user space.
>> This patch makes the driver report the touch pressure information to
>> user space.
>>
>
> What about other controllers supported by this driver? Do all of them
> report pressure? Do all have the same reporting range?
>
> Thanks.
>
> --
> Dmitry
>
