Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291Ab0J0Nzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:55:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab0J0Nzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:55:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/2] asm-generic/io.h: add reads[bwl]/writes[bwl] helpers
Date: Wed, 27 Oct 2010 15:55:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1288145006-31108-1-git-send-email-vapier@gentoo.org> <1288145006-31108-2-git-send-email-vapier@gentoo.org>
In-Reply-To: <1288145006-31108-2-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010271555.21201.arnd@arndb.de>
X-Provags-ID: V02:K0:kRA7Ans9HbxJGky21Qe4pSFgA7Tc3RMrIuNFHFzGQNs
 I5heodgBEUvBiGwr71mnHmpRjRJQxraD+CikqlB9uraHhYfWVb
 Qw1CjVcKWecM4lKjqv3UPX9r3GPOooBFxS/NepjvuUuE9TJjh7
 rArrQmMGg7kG+TtRs0frhsamIN/xs3Io6Yivo8V7bPkGmhGKBg
 8XJTaY107kM8ACFEvD5Ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 October 2010, Mike Frysinger wrote:
> A bunch of arches define reads[bwl]/writes[bwl] helpers for accessing
> memory mapped registers.  Since the Blackfin ones aren't specific to
> Blackfin code, move them to the common asm-generic/io.h for people.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Just keep it in your series to make it clear where it comes from.
I'd put it before the other one though.

Acked-by: Arnd Bergmann <arnd@arndb.de>
