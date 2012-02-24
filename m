Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2BXQiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:38:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2BXQiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:38:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in cond_syscall
Date: Fri, 24 Feb 2012 16:38:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F47981F.4020305@imgtec.com> <201202241119.44480.vapier@gentoo.org> <201202241637.30284.arnd@arndb.de>
In-Reply-To: <201202241637.30284.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241638.12205.arnd@arndb.de>
X-Provags-ID: V02:K0:qgZemHvYuxPtBSwjZZx9rQIm+Mol3AkIGa/r7lFn3q/
 QUQ7kbnAGR1tSvsyfRliJHMmUot9xkO2kqFkY6OtXZY+3TYKAW
 AJELxItx4rZm8PvPMFvW+m/kycj5nvoefDpCMweuyHZ4RO+smJ
 bJgbrQDnzT6upul0zjpjX4jQqCrBTxP1qC9JWHFrTHMoD7OMK1
 eP4m5qKBIcTMLl6eB/gR3VR7Trs5FxXbz8isyYHZH2j3tVmrxs
 gxrQ0SMTOzUD60VRrpxSe6QOKb6LmCRzL3oWqH4NPZft1XvIqt
 zoC2ms21Yzv0cNevGFdfFaNxF9B30O/G3qiegm4hanbFM2m7e+
 jHBefmcRRiOGp+Uzm6X4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 February 2012, Arnd Bergmann wrote:
> We actually have MODULE_SYMBOL_PREFIX providing the correct string
> under a name that is not appropriate here. We can probably stick with
> Jason's patch for now and add a more sophisticated logic if another
> user of CONFIG_SYMBOL_PREFIX comes up.
> 
> So for Jason's patch:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> We could put that into the kernel now, but it's probably sufficient if
> Jason keeps the patch with his others and submits it at the same time
> when we get there.

Sorry, I meant s/Jason/James/g
