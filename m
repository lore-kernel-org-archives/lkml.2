Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab2HNSj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:39:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2HNSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:39:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH 0/2] Align MIPS swapper_pg_dir for faster code.
Date: Tue, 14 Aug 2012 18:39:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
References: <1344967681-13179-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1344967681-13179-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208141839.41441.arnd@arndb.de>
X-Provags-ID: V02:K0:i21pUrDBuA6vgW6GO8ZWM1ouWOKa4IeboWcf3hAMtAd
 OmAMrR12HTamt1WW5Hhh43SeC9JPiMf62FUKyvCHwFgAOR2wS6
 mvl108NOgoTwZjnGUb/LMSJX55MRiRdlYv4CQxYkiIEHByeDG4
 gnvrtz6VAmId8jM3OXElM1rdRMiksNqYfEL+0Pe1A4hf4H/UXZ
 6HLP0olEmOrPRYD63wFSqigEWUqGUdyjGvAbhW8hV0/YtlisTo
 y44X1jRen0oGHYBslNM1i/K8ENfykwOPaUu+64J+0SzIvL7sw6
 btBy5RzRQB5c/7EVsBmId8jcWlhra6xiZSAAe4dXX6byB9e7OS
 DQ5VSZAk1EJZyOGd+iSQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, David Daney wrote:
> Since the initial use of the code is for MIPS, perhaps both parts
> could be merged by Ralf's tree (after collecting any Acked-bys).

Acked-by: Arnd Bergmann <arnd@arndb.de>
