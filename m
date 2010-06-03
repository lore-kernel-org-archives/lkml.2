Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab0FCEZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:25:27 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:57368 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0FCEZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:25:27 -0400
MIME-Version: 1.0
In-Reply-To: <1275537827-28921-2-git-send-email-w.sang@pengutronix.de>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com> 
	<1275537827-28921-2-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Jun 2010 22:25:06 -0600
X-Google-Sender-Auth: PKS0QrETlC26h26bAoR0ZuDRXY8
Message-ID: <AANLkTimSnXVynWoU_1C9NXEjfTsQjehnmn-y8Kl4txcR@mail.gmail.com>
Subject: Re: [PATCH 2/2] of/crypto: n2_core: fix build breakage
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 10:03 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/crypto/n2_core.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

Anatolij already posted a patch for this; and David let me know that
it has already been fixed in the crypto tree, so I dropped it before
pushing my tree out.

g.
