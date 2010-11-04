Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0KDKSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:18:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63484 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab0KDKSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:18:34 -0400
Subject: Re: [PATCH] regulator: lock supply in regulator enable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        elinwal <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
In-Reply-To: <4CD2847B.1060009@stericsson.com>
References: <4CD2847B.1060009@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 10:18:30 +0000
Message-ID: <1288865910.3277.23.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 11:01 +0100, Mattias Wallin wrote:
> This patch add locks around regulator supply enable.
> 
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> ---
> The previous patch I sent solves a problem seen in our system.
> This patch does not solve a problem I have seen but I still think
> it should be there. Or at least some locking of the supply in regulator enable.
> What do you guys think?

This sounds like guesswork. What exactly is the problem in your system ?

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

