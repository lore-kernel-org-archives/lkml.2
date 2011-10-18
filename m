Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1JRRKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:10:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59867 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab1JRRKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <201110181003.46805.dmitry.torokhov@gmail.com>
References: <1318952886-835-1-git-send-email-ricardo.ribalda@gmail.com>
 <201110180953.34156.dmitry.torokhov@gmail.com> <CAPybu_16xkTK1dn_NKzduxb6Q=fESyi6d0mDswkDqUMOtoPfcg@mail.gmail.com>
 <201110181003.46805.dmitry.torokhov@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 18 Oct 2011 19:10:01 +0200
Message-ID: <CAPybu_3hT3aPNeFuy=cwj2bUp7wtsVAZq1KMnfgvKsT8zRgicA@mail.gmail.com>
Subject: Re: [PATCHv3 6/7] input/cma3000_d0x: Unwind reverse order of init
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: sameo@linux.intel.com, peter.ujfalusi@ti.com, aghayal@codeaurora.org,
        david@hardeman.nu, Shubhrajyoti@ti.com, saaguirre@ti.com,
        jic23@cam.ac.uk, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,

 I remove that patch and fix it for the new cmr3000 driver


    Thanks!

On Tue, Oct 18, 2011 at 19:03, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tuesday, October 18, 2011 09:57:24 AM Ricardo Ribalda Delgado wrote:
>> Hello Dmitry
>>
>>  You are right, and also could be a good idea to init the irq, only
>> after the input device has been registered. Dont you think so?
>
> Input core is constructed in such way that it is safe to call
> input_report_*() and input_event() on properly allocated input device,
> even if it has not been registered yet, the events will simply be
> dropped.
>
> So no, it is not necessary and doing so is quite often complicates
> error handling in probe() routines.
>
> Thanks.
>
> --
> Dmitry
>



-- 
Ricardo Ribalda
