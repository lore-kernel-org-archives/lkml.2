Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2A0OH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:07:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44704 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2A0OHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:07:55 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3808@EXMAIL03.scwf.nsc.com>
References: <AczYZ9XQzl/GODbbQ8iok7bA14umkA==>
	<B567DBAB974C0544994013492B949F8E3812CD3808@EXMAIL03.scwf.nsc.com>
Date: Fri, 27 Jan 2012 15:07:54 +0100
Message-ID: <CACRpkdbWc8F1sHm+TqYSh8FmYNwWGNbEQshtkrfznf04_ZbFLg@mail.gmail.com>
Subject: Re: [PATCH 3/4] leds-lp5521: support led pattern data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 7:09 PM, Kim, Milo <Milo.Kim@ti.com> wrote:

> The lp5521 has autonomous operation mode without external control.
> Using lp5521_platform_data, various led patterns can be configurable.
> For supporting this feature, new functions and device attribute are added.

Good looking patch and interesting feature!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
