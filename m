Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0HPM1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:27:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49821 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0HPM1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rG7tUlZjLivtrssV0vv0b0kn0jzkhyhTum5MCWVVY7vQCeh0Hbyn5fLhk0jvAh4RkR
         wPsjXNtvEquHUKp0I1RuzEKSLMexGF0b1ZAcbxZPp/HW7BVTDxHmhu8Gl+n+QqD0GE0O
         t91QpMqlsC0SzZ1PTl/vw8F8MIxocMWK8GYd0=
MIME-Version: 1.0
In-Reply-To: <19561.10098.732048.877464@ipc1.ka-ro>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-2-git-send-email-s.hauer@pengutronix.de>
	<19561.10098.732048.877464@ipc1.ka-ro>
Date: Mon, 16 Aug 2010 14:27:15 +0200
Message-ID: <AANLkTi=otwukcL2RM3P=hdAgzY+QDv99abQh4QXtVuqo@mail.gmail.com>
Subject: Re: [PATCH 1/3] dmaengine: add possibility for cyclic transfers
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/16 Lothar Waﬂmann <LW@karo-electronics.de>:

> Why not implement this feature using cyclic SG lists (created with
> sg_chain())? This would give you endless DMA transfers without any
> special DMA API extensions.

That would be elegant...

The driver will have to detect that the sglist is chained like an
ouroboros to program the DMAC apropriately, is is easy to
detect if an sglist is chained onto itself?

Yours,
Linus Walleij
