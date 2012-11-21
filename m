Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab2KUKUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:20:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36635 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2KUKUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:20:42 -0500
Message-ID: <50ACAAF5.2030002@gmail.com>
Date: Wed, 21 Nov 2012 11:20:37 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Dove pinctrl fixes and DT enabling
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
In-Reply-To: <CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 10:59 AM, Linus Walleij wrote:
> On Mon, Nov 19, 2012 at 10:39 AM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com>  wrote:
>> This patch relies on a patch set for mvebu pinctrl taken through
>> Linus' pinctrl branch. As there is no other platform than Dove
>> involved, I suggest to take it though Jason's tree to avoid any
>> further conflicts.
>
> Sounds like a plan. So you have some commit history pulled
> in from the pinctrl tree in the MVEBU tree?

Linus,

I am referring to patches for a pinctrl/mvebu subfolder. IIRC Thomas
posted that patch a while ago. Jason is currently sorting things out
for mvebu pull requests. I guess both can comment on your question,
as I don't fully understand it.

Sebastian
