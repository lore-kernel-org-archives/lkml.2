Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2DBPeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:34:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41468 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2DBPeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:34:22 -0400
Message-ID: <4F79C6F7.4070701@wwwdotorg.org>
Date: Mon, 02 Apr 2012 09:34:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linus.walleij@stericsson.com, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com, sjg@chromium.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 6/6] pinctrl: tegra: Add complete device tree support
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>	<1332265479-1260-6-git-send-email-swarren@wwwdotorg.org> <CACRpkdav8x-Td-fH1Ree83GhNR8r7aA1dBsTQo2eU3nwwam21Q@mail.gmail.com>
In-Reply-To: <CACRpkdav8x-Td-fH1Ree83GhNR8r7aA1dBsTQo2eU3nwwam21Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 11:29 AM, Linus Walleij wrote:
> On Tue, Mar 20, 2012 at 6:44 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
>> complete specification of the desired pinmux configuration using device
>> tree.
>>
>> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
>> ---
>> v2: Rebase on of_property_for_each_string() API changes.
> 
> Stephen is this eligible for merge? Or does it need changes on top
> of the v4 core patch?

I believe if you take everything from v3, except replace the one patch
that I posted a v4 for, and you'll be set. I don't believe the v4
changes in the intermediate patch required and changes to any later
patches. Let me know if you want me to repost the series, thanks!
