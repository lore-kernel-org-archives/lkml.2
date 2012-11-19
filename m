Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2KSRh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:37:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62189 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2KSRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <50AA5E41.3040705@wwwdotorg.org>
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
	<CAB4BAktsPviZ11QjSGgdzaV0uvLq3TLk4au6=dOgv7NtA9nc4Q@mail.gmail.com>
	<CAKohpo=XZ_uXJPUr2dJFBQBWnkRyV2YepikrWZ2GdrPXEmEmYw@mail.gmail.com>
	<50AA5E41.3040705@wwwdotorg.org>
Date: Mon, 19 Nov 2012 23:07:56 +0530
Message-ID: <CAKohpo=grCNtQPUi2TzG+cCreETzEeBv5R9-0NLio1MRDAGDzA@mail.gmail.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16
 variables & arrays
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        "linaro-dev@lists.linaro.org Devel" <linaro-dev@lists.linaro.org>,
        andriy.shevchenko@intel.com, Patch Tracking <patches@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2012 21:58, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Support for byte- and word- properties is relatively recent I believe
> (or at least, the /bits/ syntax is). Which dtc version are you using?

Ok, i was on a older version. I just saw this patch now:

commit cd296721a9645f9f28800a072490fa15458d1fb7
Author: Stephen Warren <swarren@nvidia.com>
Date:   Fri Sep 28 21:25:59 2012 +0000

    dtc: import latest upstream dtc

    This updates scripts/dtc to commit 317a5d9 "dtc: zero out new label
    objects" from git://git.jdl.com/software/dtc.git.

    This adds features such as:
    * /bits/ syntax for cell data.
    * Math expressions within cell data.
    * The ability to delete properties or nodes.
    * Support for #line directives in the input file, which allows the use of
      cpp on *.dts.
    * -i command-line option (/include/ path)
    * -W/-E command-line options for error/warning control.
    * Removal of spew to STDOUT containing the filename being compiled.
    * Many additions to the libfdt API.

    Signed-off-by: Stephen Warren <swarren@nvidia.com>
    Acked-by: Jon Loeliger <jdl@jdl.com>
    Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Will try it tomorrow

--
viresh
