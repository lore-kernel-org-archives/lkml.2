Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0JaTPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 15:15:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33781 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab0JaTPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 15:15:03 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.188.124]
In-Reply-To: <4CCDA454.708@arndnet.de>
References: <4CCDA454.708@arndnet.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 31 Oct 2010 21:14:43 +0200
Message-ID: <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com>
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error -16
To: Arnd Hannemann <arnd@arndnet.de>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Oct 31, 2010 at 7:16 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
> b43-sdio: probe of mmc0:0001:1 failed with error -16

It's exactly what Daniel is experiencing with the XO-1.5.

In Daniel's scenario, mmc_sdio_init_card() fails because
mmc_send_relative_addr() returns -110.

Can you please check out if that's the same thing you have too ?

Thanks,
Ohad.
