Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab0EaKIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:08:09 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:55275 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0EaKIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KtWcMvo4n6opi+buMQleenGKH64m8Sa8SF2ZGIND+PIqeIy3dIKK8+0zOtPP3PLz7F
         xl10OHFamPPfRH3sE/A1/hPPrFrzuQQuCo6sfgVFiD+etYu4sJx+GfsVlCXEZKwq05oQ
         dCCI6VjpTeh7zew8L7XmzaYmywLCTljB/4xbE=
MIME-Version: 1.0
In-Reply-To: <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	<AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
Date: Mon, 31 May 2010 15:08:04 +0500
Message-ID: <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
Subject: Re: [PATCH 00/14] EVM
From: Shaz <shazalive@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> EVM is based on EA while Aegis does not use EA as far as I can
> understand from the documentation available. Can we make EVM
> independent of EA? Even the MAC mechanism is very different then
> existing LSM based mechanisms.

Have a look at the following:

http://research.nokia.com/files/NRCTR2008010.pdf
http://research.nokia.com/files/NRCTR2008007.pdf
http://lwn.net/Articles/372937/


-- 
Shaz
