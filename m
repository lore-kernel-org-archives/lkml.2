Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2KSGax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:30:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37465 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2KSGaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:30:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAB4BAks+eym9+qNZjxwkg7XxJrMwkaYFWGM5_YQk_TzfxyoHaw@mail.gmail.com>
References: <64c5278ebdec503f83e9b7002bf13affb7f3260f.1351225085.git.viresh.kumar@linaro.org>
	<50991C41.50705@gmail.com>
	<CAOh2x==LNuSFftB1r8cyJ6TOqOVJfExMTUVxKZnS16wL4B8eBA@mail.gmail.com>
	<509FB25F.3030307@gmail.com>
	<CAKohpoksQ4ShO_QFAQORO2_oEgNtOeENFnX1C3gN_5POQSGexg@mail.gmail.com>
	<509FFF8B.3010707@gmail.com>
	<CAKohponUFABC397w=dq7j+1f5QeiOX4BCOXv=OZSNOaOTmt9oQ@mail.gmail.com>
	<CAKohponUt4264UaxM2Wr41=fbPJkUCFhKhOapjPQC=OYDuyMbQ@mail.gmail.com>
	<CAB4BAks+eym9+qNZjxwkg7XxJrMwkaYFWGM5_YQk_TzfxyoHaw@mail.gmail.com>
Date: Mon, 19 Nov 2012 12:00:52 +0530
Message-ID: <CAKohpo=U2xss6cZMBKsbLJ4G-AWeEnHz8V-HFw2NKx0fucTK8Q@mail.gmail.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16
 variables & arrays
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rajanikanth HV <rajanikanth.hv@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linaro-dev@lists.linaro.org Devel" <linaro-dev@lists.linaro.org>,
        andriy.shevchenko@intel.com, Patch Tracking <patches@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2012 11:54, Rajanikanth HV <rajanikanth.hv@linaro.org> wrote:
>> data1 = /bits/ 8 <0x50 0x60 0x70>;
> as per spec, format for data byte defines will be:
> data1 = [ 0x50 0x60 0x70 ];
> however, i see a parse error from device tree compiler when i tried.

Firstly you tried square braces [ ], I am not sure if that is allowed.
Can you point me to the specification?

And simply passing 0x50, 0x60 etc.. will make them u32 instead of
u8. i.e. they will be stored as 0x00000050, etc.

--
viresh
