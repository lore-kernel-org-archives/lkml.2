Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2KZOn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:43:27 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37570 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2KZOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:43:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121126141108.GK9411@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
	<1353657795-1725-4-git-send-email-thomas.abraham@linaro.org>
	<20121124175954.GI4719@opensource.wolfsonmicro.com>
	<CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
	<20121126095141.GC9411@opensource.wolfsonmicro.com>
	<CAJuYYwTt+1-zU3092GmrK2GHR=5QDGT-diVcm_0pe3=oqhuQdA@mail.gmail.com>
	<20121126141108.GK9411@opensource.wolfsonmicro.com>
Date: Mon, 26 Nov 2012 20:13:23 +0530
Message-ID: <CAJuYYwRRauS54nt3QxyofqSyKGcJ+T_9tnjGSt60LtGOnP+ccA@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 19:41, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Nov 26, 2012 at 07:16:04PM +0530, Thomas Abraham wrote:
>
>> and this patch applied cleanly. Could you please let me know if there
>> is anything I need to be doing differently for this.
>
> Hrm, try applying it on the relevant topic branch.  Your comments about
> rebasing on top of MFD changes did suggest that there's something in the
> MFD tree so I didn't check terribly closely.

I tried applying this patch on the max8997 branch in your regulator
tree. But this patch does not apply cleanly on that branch because
commits "5eb9f2b96381" (regulator: remove use of __devexit_p),
"a5023574d120" (regulator: remove use of __devinit) and "8dc995f56ef7"
(regulator: remove use of __devexit) are not available on this branch
but these commits are already in your for-next branch.

I am not sure if it is of any help in rebasing this patch to the
existing max8997 branch. If you could suggest on how I could prepare
this patch so that applies cleanly for you, I could do that.

Thanks,
Thomas.
