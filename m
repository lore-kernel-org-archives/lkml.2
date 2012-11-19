Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2KSGYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:24:23 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:60107 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2KSGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:24:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohponUt4264UaxM2Wr41=fbPJkUCFhKhOapjPQC=OYDuyMbQ@mail.gmail.com>
References: <64c5278ebdec503f83e9b7002bf13affb7f3260f.1351225085.git.viresh.kumar@linaro.org>
	<50991C41.50705@gmail.com>
	<CAOh2x==LNuSFftB1r8cyJ6TOqOVJfExMTUVxKZnS16wL4B8eBA@mail.gmail.com>
	<509FB25F.3030307@gmail.com>
	<CAKohpoksQ4ShO_QFAQORO2_oEgNtOeENFnX1C3gN_5POQSGexg@mail.gmail.com>
	<509FFF8B.3010707@gmail.com>
	<CAKohponUFABC397w=dq7j+1f5QeiOX4BCOXv=OZSNOaOTmt9oQ@mail.gmail.com>
	<CAKohponUt4264UaxM2Wr41=fbPJkUCFhKhOapjPQC=OYDuyMbQ@mail.gmail.com>
Date: Mon, 19 Nov 2012 11:54:21 +0530
Message-ID: <CAB4BAks+eym9+qNZjxwkg7XxJrMwkaYFWGM5_YQk_TzfxyoHaw@mail.gmail.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16
 variables & arrays
From: Rajanikanth HV <rajanikanth.hv@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linaro-dev@lists.linaro.org Devel" <linaro-dev@lists.linaro.org>,
        andriy.shevchenko@intel.com, Patch Tracking <patches@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2012 09:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 12 November 2012 09:03, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 12 November 2012 01:12, Rob Herring <robherring2@gmail.com> wrote:
>>> I don't think the size is stored in the dtb. It is only in the dts. You
>>> need to define the size in the binding definitions and use '/bits/'
>>> annotation. With this the data is packed. Then the array function used
>>> should match what the binding defines.
>
> Hi Rob,
>
> Can you please help me in getting the correct format to do this from dts.
> I tried:
>
> data1 = /bits/ 8 <0x50 0x60 0x70>;
as per spec, format for data byte defines will be:
data1 = [ 0x50 0x60 0x70 ];
however, i see a parse error from device tree compiler when i tried.
>
> as written in your earlier mail... but it didn't worked. Tried to
> search too, but
> couldn't find it.
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
