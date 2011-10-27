Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1J0PmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:42:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45589 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1J0PmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:42:12 -0400
MIME-Version: 1.0
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Date: Thu, 27 Oct 2011 17:42:10 +0200
Message-ID: <CAHR064i7SsGvpzvrZo7aniAK6zE5kYNxgWjnBMuPL6u1btRoWw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Pegatron Lucid series for asus-laptop
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentincj@iksaif.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,
Do you think these patch will be able to make it to 3.2 ?
Thanks,

On Fri, Oct 14, 2011 at 11:13 AM, Corentin Chary <corentincj@iksaif.net> wrote:
> Hi,
> This is a series of patch that were staging in my tree for
> way too long. I hope they will make it to the next merge window.
> Thanks,
>
> Andy Ross (4):
>  asus-laptop: Platform detection for Pegatron Lucid
>  asus-laptop: Pegatron Lucid ALS sensor
>  asus-laptop: allow boot time control of Pegatron ALS sensor
>  asus-laptop: Pegatron Lucid accelerometer
>
> Anisse Astier (2):
>  asus-laptop: pega_accel - Report accelerometer orientation change
>    through udev
>  asus-laptop: Add rfkill support for Pegatron Lucid tablet
>
> Corentin Chary (2):
>  asus-laptop: hide leds on Pegatron Lucid
>  asus-laptop: fix module description
>
>  drivers/platform/x86/Kconfig       |   19 +-
>  drivers/platform/x86/asus-laptop.c |  366 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 363 insertions(+), 22 deletions(-)
>
> --
> 1.7.3.4
>
>



-- 
Corentin Chary
http://xf.iksaif.net
