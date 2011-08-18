Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1HRV0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:26:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65183 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1HRV0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 18 Aug 2011 14:26:20 -0700
Message-ID: <CAB=NE6UN4DEPNwt+TpOk6evr8_oz=ESqKWWGFh9KfROG1LJmiQ@mail.gmail.com>
Subject: Re: [PATCH] ath9k: make driver usable standalone
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 8:28 PM, Pavel Ivanov <paivanof@gmail.com> wrote:
> When ath9k is the only wireless driver included in the build
> WIRELESS_EXT configuration option becomes undefined. Because of that
> driver becomes essentially unusable as you can't actually connect to
> any WiFi network. By including WIRELESS_EXT into Kconfig we ensure
> that build with ath9k and without other drivers (having WIRELESS_EXT
> selected in their Kconfig) is actually usable.
>
> Signed-off-by: Pavel Ivanov <paivanof@gmail.com>

Fuck no, NACK.

  Luis
