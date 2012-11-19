Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab2KSGfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:35:50 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36036 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2KSGfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:35:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=U2xss6cZMBKsbLJ4G-AWeEnHz8V-HFw2NKx0fucTK8Q@mail.gmail.com>
References: <64c5278ebdec503f83e9b7002bf13affb7f3260f.1351225085.git.viresh.kumar@linaro.org>
	<50991C41.50705@gmail.com>
	<CAOh2x==LNuSFftB1r8cyJ6TOqOVJfExMTUVxKZnS16wL4B8eBA@mail.gmail.com>
	<509FB25F.3030307@gmail.com>
	<CAKohpoksQ4ShO_QFAQORO2_oEgNtOeENFnX1C3gN_5POQSGexg@mail.gmail.com>
	<509FFF8B.3010707@gmail.com>
	<CAKohponUFABC397w=dq7j+1f5QeiOX4BCOXv=OZSNOaOTmt9oQ@mail.gmail.com>
	<CAKohponUt4264UaxM2Wr41=fbPJkUCFhKhOapjPQC=OYDuyMbQ@mail.gmail.com>
	<CAB4BAks+eym9+qNZjxwkg7XxJrMwkaYFWGM5_YQk_TzfxyoHaw@mail.gmail.com>
	<CAKohpo=U2xss6cZMBKsbLJ4G-AWeEnHz8V-HFw2NKx0fucTK8Q@mail.gmail.com>
Date: Mon, 19 Nov 2012 12:05:47 +0530
Message-ID: <CAB4BAktsPviZ11QjSGgdzaV0uvLq3TLk4au6=dOgv7NtA9nc4Q@mail.gmail.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16
 variables & arrays
From: Rajanikanth HV <rajanikanth.hv@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linaro-dev@lists.linaro.org Devel" <linaro-dev@lists.linaro.org>,
        andriy.shevchenko@intel.com, Patch Tracking <patches@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2012 12:00, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Firstly you tried square braces [ ], I am not sure if that is allowed.
> Can you point me to the specification?
http://www.devicetree.org/Device_Tree_Usage
"
a-byte-data-property = [0x01 0x23 0x34 0x56];
"
>
> And simply passing 0x50, 0x60 etc.. will make them u32 instead of
> u8. i.e. they will be stored as 0x00000050, etc.
>
> --
> viresh
