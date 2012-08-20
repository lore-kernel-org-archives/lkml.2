Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2HTOva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:51:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49677 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2HTOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:51:26 -0400
Message-ID: <50324EE8.9010206@gmail.com>
Date: Mon, 20 Aug 2012 16:51:20 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 01/11] pinctrl: mvebu: pinctrl driver core
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>	<1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>	<CACRpkda0wUW4E3y=ucGRFu5fwwyFWo2dc=4qBaH6CFSOW2ZL_A@mail.gmail.com>	<CABJ1b_TCF=Jfb0uuoh-M87n6faezj4OqZ4S_nJLA0yKga2-ioQ@mail.gmail.com> <CACRpkdaozBQPe1PkjaKrnqYZ=tpX1mv1iS-rCrJaSFAsQqzgnA@mail.gmail.com>
In-Reply-To: <CACRpkdaozBQPe1PkjaKrnqYZ=tpX1mv1iS-rCrJaSFAsQqzgnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 04:18 PM, Linus Walleij wrote:
>> I'll review the variant types but inside pinctrl-mvebu variant
>> is used as a bit mask to distinguish different variants. Anyway,
>> they should always be the same size.
>
> Aha bitmask, seems you can only have 8 different variants of
> the Marvell's then?

Only 8 different variants of one SoC! Currently, there are 5 for
Kirkwood, none for Dove. I think there are two more Kirkwood's that
never appeared in public, but it is still < 8.

>> Well, I see if I can clarify the description but wrt the datasheet it
>> _should_ be quite obvious.
>
> I mainly worry about being able to read the code and figure out
> what's going on, if the datasheet is vital then pls include some
> link to it or so in the header of the file (but preferrably the code
> should speak for itself).

Ok, I clarify whats meant by mvebu_*_ctrl/ctrl_setting/mode. I am not
that happy with that names either, but honestly pinctrl core already
took all names that I'd have chosen. Therefore, I chose some that do
not interfere with pinctrl core as the meaning is different.

Sebastian
