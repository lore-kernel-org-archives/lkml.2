Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2KUJ7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:59:42 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63866 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2KUJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:59:40 -0500
MIME-Version: 1.0
In-Reply-To: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Wed, 21 Nov 2012 10:59:39 +0100
Message-ID: <CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
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

On Mon, Nov 19, 2012 at 10:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This patch relies on a patch set for mvebu pinctrl taken through
> Linus' pinctrl branch. As there is no other platform than Dove
> involved, I suggest to take it though Jason's tree to avoid any
> further conflicts.

Sounds like a plan. So you have some commit history pulled
in from the pinctrl tree in the MVEBU tree?

Yours,
Linus Walleij
