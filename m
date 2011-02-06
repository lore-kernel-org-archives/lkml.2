Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1BFMaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:13 -0500
Received: from smtp2.vol.cz ([195.250.128.75]:24428 "EHLO smtp1.vol.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752683Ab1BFMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:04 -0500
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Feb 2011 07:30:04 EST
Subject: Re: [PATCH 4/4] m68k/atari: ARAnyM - Add support for network access
From: Petr Stehlik <pstehlik@sophics.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        cz-bobek-lists-aranym@lists.bobek.cz,
        Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
        Milan Jurik <M.Jurik@sh.cvut.cz>, netdev@vger.kernel.org
In-Reply-To: <1296989469-7844-5-git-send-email-geert@linux-m68k.org>
References: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
	 <1296989469-7844-5-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 13:30:01 +0100
Message-ID: <1296995401.1960.50.camel@joy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven píše v Ne 06. 02. 2011 v 11:51 +0100:
> From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> 
> Should be signed off by Milan and Petr, really.
> 
> [geert] Cleanups and updates
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Petr Stehlik <pstehlik@sophics.cz>

Signed-off-by: Petr Stehlik <pstehlik@sophics.cz>

Petr

P.S. you might want to update the URL - ARAnyM got its own domain:

> +	" S.Opichal, M.Jurik, P.Stehlik\n"
> +	KERN_INFO " http://aranym.atari.org/\n";

+	KERN_INFO " http://aranym.org/\n";


