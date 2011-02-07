Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1BGTbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:31:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1BGTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:31:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH 11/20] hpfs: move to drivers/staging
Date: Mon, 7 Feb 2011 20:31:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-12-git-send-email-arnd@arndb.de> <alpine.DEB.1.10.1102071716420.31987@artax.karlin.mff.cuni.cz>
In-Reply-To: <alpine.DEB.1.10.1102071716420.31987@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072031.31608.arnd@arndb.de>
X-Provags-ID: V02:K0:I7dLVXXWRX23LLW8XsJtLUuWct7DNHAPiO4wPiTonvs
 9Cu/pvKrwO5mtIPciaFalFApKNe+i6ntD/JE++Nlvf/r86Y5zl
 g5QxUIgv+GqLo3TRkNywkiQpG+rcF+MvpdqP6PvQ6jEpK/k3L0
 OfBx8fFIDlNnGUJ2ieUhEK5IJiWrqXScbsVy/VtIRRl0uE5x86
 6O9qYJ61XNrtJv2Ak1nOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 February 2011 17:17:37 Mikulas Patocka wrote:
> 
> Hey, I will solve it sometimes, but I am in a mental hospital now.

Hi Mikulas,

Good to hear that you are still interested in the code. I'll make
sure we don't just remove it then, but I suppose we can still
mark it as non-SMP in the meantime.

I hope you get well soon,

	Arnd
