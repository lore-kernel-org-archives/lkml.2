Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab2D3Qih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:38:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab2D3Qif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:38:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
Date: Mon, 30 Apr 2012 16:38:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org> <201204301415.56690.arnd@arndb.de> <4F9EBF3E.8060401@codeaurora.org>
In-Reply-To: <4F9EBF3E.8060401@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301638.29398.arnd@arndb.de>
X-Provags-ID: V02:K0:4ShKoKy4u9cSFKtZBHBCSLF0ZeqhvSBDJ3XEvhfnlxv
 sMfxuDmHEoicPIr9k/gsLwV8wzSBdBSgkGEYRQ+4GFCoUjnGLA
 kKDKWkybVsO4AMZtdIe1LQbHv9rPd/02GbTkipiX/v9Gitspin
 LtiM45aYif+yJnIECDTdYz3bqozfLg8wFwgXEjCDVe21hJKO8V
 QOO9YaSWkEMI6G3s5Na9qvi8C6erFjvB9I5tYP4l1DB1tMGk1u
 l8VPgQGpY2xNnuiMhS9E4y3Sz6afVZl3SbdIsW9CaNOSc2NeK4
 rMFhn2sJul3i32elcf6MUe+Dl1xaG2CJGHs1NfcyDNoSPWJkja
 14SX1noRZz+PQvwpYBX8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2012, Stephen Boyd wrote:
> I admit I haven't compile tested this on all the affected architectures.
> Looking at the architectures that are migrated here I don't see any that
> are defining get_current() as a macro except for alpha. Should I drop
> alpha from the patch? Or would it be easier if someone threw this into
> linux-next and see if it blows up?
> 
> In the meantime I can scrounge around for those kernel.org
> cross-compilers and see if I can compile alpha.

I'd say either get an Ack from the Alpha maintainers or drop that
hunk from your patch.

	Arnd
