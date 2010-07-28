Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0G1JEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:04:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46417 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0G1JEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bOpDy6+9RxhpdTUlRbXPGB5KMUXCem8ggxjxvSxFy7PojNlc+vpMVZwRXZaywhldV3
         /F9Fq9Hysl0JlUYtJzv7AyGWShpUpHxHxreClh8Rsx7Ulhq1CuaP/sCcV7y5DctD7Wny
         2axdIutXvZqDwqDBVr514X1bL47v1Tlo/dBnI=
MIME-Version: 1.0
In-Reply-To: <4C4FE70A.70101@st.com>
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com> 
	<4C4FE70A.70101@st.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 28 Jul 2010 17:04:21 +0800
Message-ID: <AANLkTikV9PAbKY+CQpcgXX01MOFx36G3LMg+nZ5pEy1q@mail.gmail.com>
Subject: Re: JPEG hw decoder
To: viresh kumar <viresh.kumar@st.com>, video4linux-list@redhat.com
Cc: rd bairva <rbairva@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 4:15 PM, viresh kumar <viresh.kumar@st.com> wrote:
> On 7/28/2010 10:42 AM, rd bairva wrote:
>> Hi ,
>>       My board has a hardware JPEG decoder. I want to write a driver
>> for this in Linux kernel, But it seems there that no Framework exists
>> in kernel. Can somebody provide me some pointers?
>
> Hello Rbairva,
>
> Which JPEG decoder are you working on??
>
> I have Synopsys JPEG Decoder/Encoder on ST SPEAr platform
> and i am currently working on its driver for LKML.
>
> I already have a driver for it which is not aligned to LKML guidelines,
> and so doing modifications there.
> In my driver i have used char device framework and none other suits it well.
>

Normally the JPEG decoder/encoder comes with the video camera
module, which falls in v4l2 framework. Though not sure how well
the v4l2 API is gonna support this.

> viresh.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
