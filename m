Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1LSG0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:26:49 -0500
Received: from claw.goop.org ([74.207.240.146]:54517 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1LSG0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:26:47 -0500
Message-ID: <4EEED923.9000706@goop.org>
Date: Sun, 18 Dec 2011 22:26:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH RFC V2 0/4] Add "scope" to power supplies
References: <cover.1323454016.git.jeremy@goop.org>
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 12/09/2011 02:43 PM, Jeremy Fitzhardinge wrote:
> This series adds a "scope" attribute to power supplies, to indicate
> whether it powers the whole system ("System") or just some subset of
> the devices ("Device").  This allows upowerd to distinguish between
> system-wide power supplies and self-powered devices such as cordless
> mice.
>
> This series also adds a "powers" link to power supplies, so that if
> they're scope=Device, they can specifically indicate which device
> tree they power.
>
> Updates since last post:
>  - Add more complete documentation to scope and "powers" links
>  - Remove unnecessary scopes on System power supplies
>  - Make HID battery supplies Device, and add "powers" pointers
>    for them.
>
> This can also be pulled from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git power-supply-scope
>
> Jeremy Fitzhardinge (4):
>   power_supply: add SCOPE attribute to power supplies
>   power_supply: allow a power supply to explicitly point to powered
>     device
>   power_supply: add scope properties to some self-powered HID devices
>   power_supply: add "powers" links to self-powered HID devices
>
>  drivers/hid/hid-wacom.c            |   16 ++++++++++++++--
>  drivers/hid/hid-wiimote.c          |   10 +++++++++-
>  drivers/power/power_supply_core.c  |    7 +++++++
>  drivers/power/power_supply_sysfs.c |    6 ++++++
>  include/linux/power_supply.h       |    8 ++++++++
>  5 files changed, 44 insertions(+), 3 deletions(-)
>

