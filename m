Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab2GCBbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:31:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51482 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2GCBbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:31:09 -0400
Message-ID: <4FF24B59.1060508@wwwdotorg.org>
Date: Mon, 02 Jul 2012 19:31:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 4/6] ARM: tegra: Add clk_tegra structure and helper functions
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com> <1340879846-12900-5-git-send-email-pgaikwad@nvidia.com> <20120628182759.GA28424@gmail.com> <4FED688E.9090408@nvidia.com> <CAJOA=zMt-HWKrgQ-pD-wH0s_Nao5sJA13+ESJSBkHQ_3OBurtg@mail.gmail.com>
In-Reply-To: <CAJOA=zMt-HWKrgQ-pD-wH0s_Nao5sJA13+ESJSBkHQ_3OBurtg@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 06:09 PM, Turquette, Mike wrote:
> On Fri, Jun 29, 2012 at 1:34 AM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
>> On Thursday 28 June 2012 11:58 PM, Mike Turquette wrote:
>>> We had some discussions in the past on your clock reset and external
>>> line request operations which you've had to put into struct clk_tegra.
>>>
>>> Do you need to expose those ops to code in drivers/*?  I consider that a
>>> reasonable litmus test to start considering if something should be moved
>>> into the generic clk.h api.
>>
>>
>> Yes, we need these ops in drivers. Peter has sent a patch proposing to move
>> these ops to generic clk.
>>
>> In addition, we also need mechanism/ops to change rate and parent from
>> clk_ops implementation. There was some discussion but I do not know the
>> latest status.
>>
> 
> Hi Prashant,
> 
> OK, that is good to know.  I haven't forgotten about this topic.  I'm
> still trying to think of the best way to expose less-common operations
> to drivers...
> 
> Based on Stephen's feedback in patch 0 I'll be waiting for another
> version of this series before taking into clk-next.

Oh, does this series depend on stuff in clk-next? I was intending to
take it through the Tegra tree, since it definitely depends on (in
complex ways through context if nothing else due to to large
split/rename patches) a bunch of commits in Tegra's for-3.6/common-clk
branch.
