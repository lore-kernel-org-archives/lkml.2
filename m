Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0LJPu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:50:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52134 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0LJPuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:50:24 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH v6 1/5] Input: add input driver for polled GPIO buttons
Organization: Deep Root Systems, LLC
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<b534569073dec52718e99623858ea9dd146faf24.1291931041.git.bengardiner@nanometrics.ca>
Date: Fri, 10 Dec 2010 07:50:18 -0800
In-Reply-To: <b534569073dec52718e99623858ea9dd146faf24.1291931041.git.bengardiner@nanometrics.ca>
	(Ben Gardiner's message of "Thu, 9 Dec 2010 16:51:03 -0500")
Message-ID: <87hbeleif9.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gardiner <bengardiner@nanometrics.ca> writes:

> From: Gabor Juhos <juhosg@openwrt.org>
>
> The existing gpio-keys driver can be usable only for GPIO lines with
> interrupt support. Several devices have buttons connected to a GPIO
> line which is not capable to generate interrupts. This patch adds a
> new input driver using the generic GPIO layer and the input-polldev
> to support such buttons.
>
> [Ben Gardiner <bengardiner@nanometrics.ca: fold code to use more
>  of the original gpio_keys infrastructure; cleanups and other
>  improvements.]
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Tested-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> (cherry picked from commit 0e7d0c860a0dee49dacb7bbb248d1eba637075ad)
>
> ---
>
> This a copy of the commit -- I included in the patch series since
> linux-davinci/master does not currently have it; but 2.6.37-rc5 does.

I'll be updating davinci master to .37-rc5 today, so will drop this
patch.

Kevin

