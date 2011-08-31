Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1HaQ3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:29:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab1HaQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:29:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
Date: Wed, 31 Aug 2011 18:28:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com> <CAMbhsRRRa_JV8_LHEvsM2h3e8Hbf1GAcpXz8gdU3wCc8Jgz5gw@mail.gmail.com> <74CDBE0F657A3D45AFBB94109FB122FF04B3279D4F@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B3279D4F@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311828.40783.arnd@arndb.de>
X-Provags-ID: V02:K0:fNpK4ggAO3+QgTtSbRJQscmvY5caRD+ABO0Z/2abXQG
 TojhHz8dVtdm51KZn/YsCL5G4CIdg0r3Ae/2sjfc9HIHdSK7BG
 7EPr5eOFh/5W0+Blv2m8HWAJ+cw8KNOPLIsBtoUYcXpFYkWYa4
 sL4E+Igf1SJNhwCbLyXIOjJ4d6U09Ez2Pky0EzmWenhcCnaxeD
 KFZ4u8PdZWYj5blPMjuVXUZLe9BpP4Z9JUcFltfqkOPz6zsiPd
 kTHq+UCLjmPqD7wOT+YvYzxdv3BlfA6tpFD9zAbqjozdaXJfr8
 3m6bOGv02N60tIfy8rFwGOVNPcK8pn1qhm6eR/xZt9y8CmcvEN
 pZTq6NRGmakRMAUSkJZc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Stephen Warren wrote:
> Ben, Arnd,
> 
> Could you please ack/nack the patch at the start of this thread for Colin;
> see below.

Sorry, I normally like to give my opinion on everything, but I really don't
have a clue what this one is about. I don't understand i2c or power management ;-)

	Arnd
