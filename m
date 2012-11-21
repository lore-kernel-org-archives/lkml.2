Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2KUOpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:45:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51481 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2KUOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:45:43 -0500
MIME-Version: 1.0
In-Reply-To: <50ACAAF5.2030002@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
	<50ACAAF5.2030002@gmail.com>
Date: Wed, 21 Nov 2012 15:45:42 +0100
Message-ID: <CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] Dove pinctrl fixes and DT enabling
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:20 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 11/21/2012 10:59 AM, Linus Walleij wrote:
>>
>> On Mon, Nov 19, 2012 at 10:39 AM, Sebastian Hesselbarth
>> <sebastian.hesselbarth@gmail.com>  wrote:
>>>
>>> This patch relies on a patch set for mvebu pinctrl taken through
>>> Linus' pinctrl branch. As there is no other platform than Dove
>>> involved, I suggest to take it though Jason's tree to avoid any
>>> further conflicts.
>>
>>
>> Sounds like a plan. So you have some commit history pulled
>> in from the pinctrl tree in the MVEBU tree?
>
>
> Linus,
>
> I am referring to patches for a pinctrl/mvebu subfolder. IIRC Thomas
> posted that patch a while ago. Jason is currently sorting things out
> for mvebu pull requests. I guess both can comment on your question,
> as I don't fully understand it.

So what I mean is that the patches creating pinctrl/mvebu is in the
pinctrl tree, so if patches in the MVEBU tree depend on these,
then it must have pulled in a branch from pinctrl or applied the
same patches in that tree too (which is OK *sometimes*).

Yours,
Linus Walleij
