Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1GBTqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:46:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1GBTqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:46:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 2/2] iomap: make IOPORT/PCI mapping functions conditional
Date: Sat, 2 Jul 2011 21:46:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1309622006-28343-1-git-send-email-jonas@southpole.se> <1309622006-28343-2-git-send-email-jonas@southpole.se>
In-Reply-To: <1309622006-28343-2-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107022146.15854.arnd@arndb.de>
X-Provags-ID: V02:K0:yM9XOHSlP34/Oy98Baqn99oip7E/aY4uFhrQemKW8XG
 fca6QYTzFKXDRWSnuvqaB7x+ZEoTUHIKhxdCFQe515KdEwEQkN
 f3ADbhMkZ+nn3RrJ+mH9/XyPlAkaKwDtl/WF829bjlk0pM9dXQ
 d0/qktZVB89GzuFsHrTZ4EoZJKoamFttKgm/Y1yJo30r0y4YnV
 vTPBM+O+Cq1PeBNpderhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 17:53:26 Jonas Bonn wrote:
> Use the CONFIG_HAS_IOPORT and CONFIG_PCI options to decide whether or
> not functions for mapping these areas are provided.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>

Good catch!

Acked-by: Arnd Bergmann <arnd@arndb.de>

Did you get a build error without the two options, or did you just have an
idea to save a bit of code size?

	Arnd
