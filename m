Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2CRXOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 19:14:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33172 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2CRXOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 19:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	<20120317123151.AAF9A3E0952@localhost>
	<1332010422.22775.76.camel@saladin.home.flameeyes.eu>
Date: Mon, 19 Mar 2012 00:14:45 +0100
Message-ID: <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Diego_Elio_Petten=F2?= <flameeyes@flameeyes.eu>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 7:53 PM, Diego Elio Pettenò
<flameeyes@flameeyes.eu> wrote:

> Another reason to have a MFD driver would be to allow tweaking the few
> more knobs that (at least IT8728F) expose, such as the ability to switch
> a few pre-defined inputs and outputs to GPIO instead, and so on...

Hm that sounds an awful lot like pin multiplexing. Is that the case?

Yours,
Linus Walleij
