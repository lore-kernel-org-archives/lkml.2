Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2KUKA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:00:58 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50187 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2KUKAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:00:54 -0500
MIME-Version: 1.0
In-Reply-To: <1353317996-20841-3-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1353317996-20841-3-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Wed, 21 Nov 2012 11:00:53 +0100
Message-ID: <CACRpkdZy86OAYbszTZDrs+bdkkEmS9+8z450U1qX+AF4sp5C5Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: mvebu: Fix dove_audio1_ctrl_set function
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 10:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> From: Axel Lin <axel.lin@ingics.com>
>
> When setting audio1 pinmux the bits in the corresponding registers
> are not cleared. This fix first clears all bits and then sets the
> required bits according to the selected function.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
