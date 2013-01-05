Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3AECyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:54:21 -0500
Received: from [216.228.121.35] ([216.228.121.35]:3933 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3AECyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:54:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Jan 2013 18:53:37 -0800
Message-ID: <50E795AC.5030106@nvidia.com>
Date: Sat, 5 Jan 2013 08:23:32 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] clk: tegra30: Convert clk out to composite clk
References: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com> <1357278706-28149-2-git-send-email-pgaikwad@nvidia.com> <50E7027A.1090102@wwwdotorg.org>
In-Reply-To: <50E7027A.1090102@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2013 09:55 PM, Stephen Warren wrote:
> On 01/03/2013 10:51 PM, Prashant Gaikwad wrote:
>> Convert clk out to composite clock type which removes
>> the mux clock.
>>
>> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
>> ---
>> This patch is rebased on ccf-rework for Tegra patch series. It is just to show
>> how clk-composite can be used, not to be merged. If patch 1 is accepted then
>> I would like to merge this patch to ccf-rework series.
> Just so I'm clear, is the intent that patch 1 of this series gets
> reviewed/accepted, and then you'll repost an updated version of the
> Tegra CCF rework series that relies on patch 1? If so, patch 1 would
> need to be either taken through the Tegra tree, or put into a separate
> branch in the clock tree, so the Tegra tree can merge it as a dependency
> of the Tegra CCF rework branch.

Yes, that is my plan but you can tell whatever you are comfortable with. 
I will re-order the dependencies.


