Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2DXQoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:44:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34166 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2DXQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:44:00 -0400
Message-ID: <4F96D84E.7080204@wwwdotorg.org>
Date: Tue, 24 Apr 2012 10:43:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng <B29396@freescale.com>, viresh kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Tag on pinctrl
References: <CACRpkdYqZrNFxj4kyMqYZk5PAcjF6-TroJ+Xq+3EVBLvo5Zg-Q@mail.gmail.com>
In-Reply-To: <CACRpkdYqZrNFxj4kyMqYZk5PAcjF6-TroJ+Xq+3EVBLvo5Zg-Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 07:15 AM, Linus Walleij wrote:
> A while back I created a tag:
> 
> pinctrl-mergebase-20120418
> 
> On the pinctrl tree. It contains stuff up until that date that
> has since been sitting in linux-next for a while.
> 
> I do not expect to rebase these patches further. They
> are based on v3.4-rc3. So I will base any further pinctrl
> work on this.
> 
> I think Stephen needed to pull this into the ARM SoC tree?

Yes, I have pulled that tag into the Tegra tree as
for-3.5/gpio-pinmux-dependency, and have a Tegra-specific
for-3.5/gpio-pinmux branch that depends on it. Two other Tegra branches
in turn (for-3.5/tegra30-audio, for-3.5/usb-ulpi) depend on
for-3.5/gpio-pinmux.

Linus, I think this will get into the ARM SoC tree simply by my saying
in my for-3.5/gpio-pinmux pull request that the branch depends on your
tag; I don't /think/ you need to explicitly send a pull request there,
right?
