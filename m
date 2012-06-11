Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2FKDpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:45:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59003 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2FKDpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:45:52 -0400
MIME-Version: 1.0
Reply-To: rus@sfinxsoft.com
From: Rus <rus@sfinxsoft.com>
Date: Mon, 11 Jun 2012 06:45:11 +0300
X-Google-Sender-Auth: bru5lpXhyrBsWyIOUyHDLO2Gvok
Message-ID: <CAKgfjTmCkdDxhfnkscXYxFMKLWZ5o8_70jVe3Lj7UMjThKutnQ@mail.gmail.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
To: zboszor@pr.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

:Does anyone know whether it's a known problem in AMD FX CPUs?
:Does AMD have a newer microcode to fix this bug, or should I apply
:for warranty?

This is do not related to AMD microcode. The main problem is that Asus
do not tests their motherboards against supported CPU list. The next
problem  is m/b BIOS and last problem - ASUS is ignoring Linux users
and Linux as oficially supported OS on their m/b. I'm having the same
problems with FX-8150 and M5A97-PRO m/b. This m/b do not work by
default with FX-* CPU because of wrong power mode selected for this
CPU by BIOS. To make it work somehow you need to :

1. Flash the latest BIOS
2. Disable turbo core in BIOS setup
3. Enable extreme EPU mode in BIOS setup
4. Disable EPU Power Saving mode in BIOS setup
5. Use the >= 3.5 kernels (rc1 or rc2 for now)
6. Play with IOMMU mode in BIOS setup (try enable, try disable)

P.S. I'm not subscribed, so cc.

Rus

-- 
SfinxSoft
http://sfinxsoft.com
