Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab0JBSDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 14:03:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37960 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0JBSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 14:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CqaII/80o1RkjWaBO/z5/uzKYcE6l/o2m5aVQe1/CpafKqONQNEApbz9UyhgqZqnBC
         KYTGUIjU4RR0FopR+2uHQIFzlkjq4Q6GvrdB0XYdzuFky8No3X5UdOBOmp/7LeU5yN52
         fNiezzhZPbei5/xS6u84YI5y1kIplVzx1A7fA=
MIME-Version: 1.0
In-Reply-To: <1285901335-26354-2-git-send-email-ccross@android.com>
References: <1285901335-26354-1-git-send-email-ccross@android.com>
	<1285901335-26354-2-git-send-email-ccross@android.com>
Date: Sat, 2 Oct 2010 20:03:36 +0200
Message-ID: <AANLkTinSgSWakhXaHN9svA7ruRF6w4tbOugdd5g+xF2i@mail.gmail.com>
Subject: Re: [PATCH 2/2] gic: Export irq chip functions
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/1 Colin Cross <ccross@android.com>:

> Some systems combine the GIC with an external interrupt controller.

Which ones?

In-tree systems (in which case it would be natural to include these changes
the patch series) or stuff you plan to submit later?

Linus Walleij
