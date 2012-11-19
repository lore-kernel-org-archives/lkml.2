Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2KSQ24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:28:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44907 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2KSQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:28:55 -0500
Message-ID: <50AA5E41.3040705@wwwdotorg.org>
Date: Mon, 19 Nov 2012 09:28:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        "linaro-dev@lists.linaro.org Devel" <linaro-dev@lists.linaro.org>,
        andriy.shevchenko@intel.com, Patch Tracking <patches@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16 variables
 & arrays
References: <64c5278ebdec503f83e9b7002bf13affb7f3260f.1351225085.git.viresh.kumar@linaro.org> <50991C41.50705@gmail.com> <CAOh2x==LNuSFftB1r8cyJ6TOqOVJfExMTUVxKZnS16wL4B8eBA@mail.gmail.com> <509FB25F.3030307@gmail.com> <CAKohpoksQ4ShO_QFAQORO2_oEgNtOeENFnX1C3gN_5POQSGexg@mail.gmail.com> <509FFF8B.3010707@gmail.com> <CAKohponUFABC397w=dq7j+1f5QeiOX4BCOXv=OZSNOaOTmt9oQ@mail.gmail.com> <CAKohponUt4264UaxM2Wr41=fbPJkUCFhKhOapjPQC=OYDuyMbQ@mail.gmail.com> <CAB4BAks+eym9+qNZjxwkg7XxJrMwkaYFWGM5_YQk_TzfxyoHaw@mail.gmail.com> <CAKohpo=U2xss6cZMBKsbLJ4G-AWeEnHz8V-HFw2NKx0fucTK8Q@mail.gmail.com> <CAB4BAktsPviZ11QjSGgdzaV0uvLq3TLk4au6=dOgv7NtA9nc4Q@mail.gmail.com> <CAKohpo=XZ_uXJPUr2dJFBQBWnkRyV2YepikrWZ2GdrPXEmEmYw@mail.gmail.com>
In-Reply-To: <CAKohpo=XZ_uXJPUr2dJFBQBWnkRyV2YepikrWZ2GdrPXEmEmYw@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 11:41 PM, Viresh Kumar wrote:
> On 19 November 2012 12:05, Rajanikanth HV <rajanikanth.hv@linaro.org> wrote:
>> On 19 November 2012 12:00, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> Firstly you tried square braces [ ], I am not sure if that is allowed.
>>> Can you point me to the specification?
>> http://www.devicetree.org/Device_Tree_Usage
>> "
>> a-byte-data-property = [0x01 0x23 0x34 0x56];
>> "
> 
> Ok, but what about 16 bit then {} :)

Support for byte- and word- properties is relatively recent I believe
(or at least, the /bits/ syntax is). Which dtc version are you using?
