Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab2GCAJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:09:51 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:50287 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab2GCAJu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:09:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FED688E.9090408@nvidia.com>
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com>
 <1340879846-12900-5-git-send-email-pgaikwad@nvidia.com> <20120628182759.GA28424@gmail.com>
 <4FED688E.9090408@nvidia.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 2 Jul 2012 17:09:28 -0700
Message-ID: <CAJOA=zMt-HWKrgQ-pD-wH0s_Nao5sJA13+ESJSBkHQ_3OBurtg@mail.gmail.com>
Subject: Re: [PATCH 4/6] ARM: tegra: Add clk_tegra structure and helper functions
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 1:34 AM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> On Thursday 28 June 2012 11:58 PM, Mike Turquette wrote:
>> We had some discussions in the past on your clock reset and external
>> line request operations which you've had to put into struct clk_tegra.
>>
>> Do you need to expose those ops to code in drivers/*?  I consider that a
>> reasonable litmus test to start considering if something should be moved
>> into the generic clk.h api.
>
>
> Yes, we need these ops in drivers. Peter has sent a patch proposing to move
> these ops to generic clk.
>
> In addition, we also need mechanism/ops to change rate and parent from
> clk_ops implementation. There was some discussion but I do not know the
> latest status.
>

Hi Prashant,

OK, that is good to know.  I haven't forgotten about this topic.  I'm
still trying to think of the best way to expose less-common operations
to drivers...

Based on Stephen's feedback in patch 0 I'll be waiting for another
version of this series before taking into clk-next.

Thanks,
Mike
