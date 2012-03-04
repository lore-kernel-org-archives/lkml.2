Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2CDTrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:47:45 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:52902 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab2CDTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:47:43 -0500
X-Sasl-enc: L4kSidJjVaoqGW3ZtmY5Rc0Nnb/aeaeaaNAH+ILcHoxF 1330890462
Message-ID: <4F53C6D3.2060404@signal11.us>
Date: Sun, 04 Mar 2012 14:47:31 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/6] ARM: tegra: select CPU_FREQ_TABLE
References: <1330721908-8633-1-git-send-email-alan@signal11.us> <20120304183710.GB31064@quad.lixom.net>
In-Reply-To: <20120304183710.GB31064@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/12 1:37 PM, Olof Johansson wrote:
> On Fri, Mar 02, 2012 at 03:58:28PM -0500, Alan Ott wrote:
>> From: Arnd Bergmann<arnd@arndb.de>
>>
>> The tegra cpufreq implementation relies on the cpu_freq_table
>> code, so make sure that this is always there when needed.
>>
>> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
>> Signed-off-by: Alan Ott<alan@signal11.us>
>
> This didn't apply cleanly to the tegra tree (what was it based on?), but
> I fixed it up manually and applied to for-3.4/cleanups-and-fixes.
>

These were based on mainline.

Alan.
