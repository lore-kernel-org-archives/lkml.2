Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2HFOXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:23:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56879 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2HFOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:23:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/6] ARM: dove: DT support for Marvell Dove
Date: Mon, 6 Aug 2012 14:23:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com> <201208061402.22815.arnd@arndb.de> <CABJ1b_S6jRW9P7ygs7LPztbx1zW-u=gD1kk0UYbgBrHdvsaOeA@mail.gmail.com>
In-Reply-To: <CABJ1b_S6jRW9P7ygs7LPztbx1zW-u=gD1kk0UYbgBrHdvsaOeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061423.38988.arnd@arndb.de>
X-Provags-ID: V02:K0:pv/jIL39tAxTAyWX6d36+AG/m88cm6LQDuQKsKAb1A/
 eEIqBddSx5xesjgw52YiUisQEgoSasA7rl69gcD5GXiJSkqgDQ
 2YiaxKEfB0XpV2OcB6uzFnI0IUVLHofc6CibNm8ARRAXZXbOL/
 4LVz32NUpMY99tgja4sOCrBONtLOmTnkN5cz1Bb6+igXWEoJ5y
 /VdwCy6ux79ikETwRpfJMh43PIbDcowy4kTPBUqOLsCE+xBzwK
 S+ICHbP5VVzNqD1nMIvyYXbHSo7U4nxcehqDfc5xPomSIgNRLz
 cu456BooXXGjSepGY1YCGdbo1SBmSUxyOtVD4zRxy+D62DDYDu
 Zi6o22fuexDacRsp4lBw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2012, Sebastian Hesselbarth wrote:
> I suggest to keep non-DT support until we have pinctrl and gpiolib drivers
> done. Thomas Petazzoni and I have been working on pinctrl that will be
> posted in a few days and gpiolib driver needs some more cleanup but is
> basically working. Until then I guess most of the other orion drivers have
> DT support (eth and xor IIRC).

Ok, sounds resonable.

	Arnd
