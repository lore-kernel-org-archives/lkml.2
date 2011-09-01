Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1IAI23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:28:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab1IAI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:28:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/7] serial/8250: move UPIO_TSI to powerpc
Date: Thu, 01 Sep 2011 10:28:12 +0200
Message-ID: <4560783.75JgbxnBn8@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1314856926.4145.12.camel@pasglop>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <1309211120-2803-4-git-send-email-arnd@arndb.de> <1314856926.4145.12.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nOB7bGRH8sPvhL3LOxrvJ2k+0CFb1ou6MXto5Ujn6q5
 YLT5xAK9wRJZXre2YsmZe/LTs70ONuBLIttBW9EqdFaHWKMNT0
 yVjR55WEvdGo60NlTMDKDp2Iiz3t0ao81Rj50F8lWjB3AvHWGe
 thA637+Bbo9btdV0cltZ3kDwwek9IMwzfoY7csNrXulSEjGEj8
 n2LlJ/fGoOCyGgiZO/3V76EgLUR9nXzfPfnTl76vgW83SlW8nB
 6TL6sY/EsghB+DODGBsQ54kzjuGK3iP2zGDAa3GSlCwL2e70gg
 n+U9NtBWKtCWNBqv8WXJXqhbVagfevQFqeQ6Rmze9Qi54rr8kt
 pAnJ6U2ohdBHq0/jNKlg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 September 2011 16:02:06 Benjamin Herrenschmidt wrote:
> On Mon, 2011-06-27 at 23:45 +0200, Arnd Bergmann wrote:
> > This iotype is only used by the legacy_serial code in powerpc, so the
> > code should live there, rather than be compiled in for every 8250
> > driver.
> 
> Obviously untested 
> 
> Misses the definition of UART_IIR etc...
> 
> I'm committing a fixed version in my tree

Ok, thank you!

	Arnd
