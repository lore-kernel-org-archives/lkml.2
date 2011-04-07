Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1DGVvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:51:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:54976 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab1DGVvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:51:31 -0400
Subject: Re: [PATCHES] Generalize PCI <-> OF node matching
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: monstr@monstr.eu
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, bheglaas@google.com,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
In-Reply-To: <4D9DA5DF.8020303@monstr.eu>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	 <4D9DA5DF.8020303@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 07:50:59 +1000
Message-ID: <1302213059.2458.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 13:54 +0200, Michal Simek wrote:
> There are several coding style issues.
> Please look at it through checkpatch.pl.

I tend to generally ignore checkpatch :-) I have my reasons... I'll have
a quick look see if there's anything really worthwhile in there but in
general I dislike "absolute" rules such as what checkpatch imposes.

> Compilation is fine for Microblaze as you surely saw.
> I am not able to test it on real hw right now but I will ask for
> remote connection to the board.

Thanks.

Cheers,
Ben.

