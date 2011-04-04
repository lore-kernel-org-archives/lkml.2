Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1DDPdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:33:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1DDPdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:33:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Thilo-Alexander Ginkel" <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
Date: Mon, 4 Apr 2011 17:32:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com> <201104041640.15578.arnd@arndb.de> <BANLkTim4Ro+u-9jfLPV1-+tM88xtvN-VTg@mail.gmail.com>
In-Reply-To: <BANLkTim4Ro+u-9jfLPV1-+tM88xtvN-VTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041732.42489.arnd@arndb.de>
X-Provags-ID: V02:K0:df4Ku/7SGrWtBiPpAL0DP0yUycFN1m1/tCUaED983Kw
 G2d2tQExirDvbwTRxq5dzMhWn6LmZYgSXOxmsHHsyHN2yphizk
 H9q2DrUDz12R5ma0yQ7o1dKd8doG9GwLuikE/CgU37wy/9q2PC
 5tkPsaXFgqaEhAdS2kShaNT8qlqD+PXU9FTQ0AGxxqA9SD48h6
 VkPYTxVIKHw5iEnI0I7Vg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 April 2011, Thilo-Alexander Ginkel wrote:
> ACK. I see two possibilities:
> a) The bug was introduced after the bisected bug was fixed
> b) The bug was already present earlier, but was masked by the bug from
> the bisected change
> 
> I hope for a) as that would open the possibility to bisect this new bug.
> 

In case of b), you can still bisect it when you either apply the later fix
or revert the original patch whenever you build a kernel. Or you can try
to avoid using the usb-hid driver during bisect.

	Arnd
