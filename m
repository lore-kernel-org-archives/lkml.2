Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2LGEgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 23:36:51 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35375 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2LGEgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 23:36:50 -0500
MIME-Version: 1.0
X-Originating-IP: [174.112.205.165]
In-Reply-To: <20121207005833.008375861@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org> <20121207005833.008375861@linuxfoundation.org>
From: Calvin Walton <calvin.walton@kepstin.ca>
Date: Thu, 6 Dec 2012 23:36:16 -0500
Message-ID: <CAF1iTgtAtu6PbGab4Pt3ppMQs0U9nmxzUsQV-ZapCNArofmtnw@mail.gmail.com>
Subject: Re: [ 24/27] i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Peter Huewe <peterhuewe@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, dropped the CCs when I replied... I don't normally use the
Gmail web interface :)

On Thu, Dec 6, 2012 at 7:59 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Calvin Walton <calvin.walton@kepstin.ca>
>
> commit a51d4ed01e5bb39d2cf36a12f9976ab08872c192 upstream.
>
> This board is incorrectly detected as having an LVDS connector,

$ git describe --contains a51d4ed01e5bb39d2cf36a12f9976ab08872c192
v3.6-rc4~5^2~3^2

This patch was already included in Linus's 3.6 upstream release, so it
doesn't need to be (re-)applied to the 3.6.x stable tree. I'm
surprised it applied at all, it must need some fuzz to add the
duplicate entry...?

Anyways, it should only be applied to the 3.0 and 3.4 trees.

Calvin.
