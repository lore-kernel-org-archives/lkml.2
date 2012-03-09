Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2CIRKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:10:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42970 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2CIRKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:10:01 -0500
Message-ID: <4F5A3965.5040300@wwwdotorg.org>
Date: Fri, 09 Mar 2012 10:09:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2] ARM: tegra: export tegra_gpio_{en,dis}able
References: <1330630010-11241-2-git-send-email-alan@signal11.us> <1330727544-11617-1-git-send-email-alan@signal11.us> <4F5A3726.8030505@signal11.us>
In-Reply-To: <4F5A3726.8030505@signal11.us>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 10:00 AM, Alan Ott wrote:
> On 03/02/2012 05:32 PM, Alan Ott wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> These two functions are used in drivers that can be
>> modules, so they need to be exported.
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Olof Johansson <olof@lixom.net>
...
> Did this patch ever get picked up into someone's tree?

It looks like Grant ack'd it which implies the thought Olof was going to
take it through the Tegra tree perhaps? But Olof did the same, so is
probably waiting for Grant to take it...
