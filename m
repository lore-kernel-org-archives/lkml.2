Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HGXSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 19:18:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1HGXSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 19:18:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Regression] Boot crash caused by commit 1eb19a12bd2214cdcad5273d472b062a4ba97fa1
Date: Mon, 8 Aug 2011 01:19:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: msb@chromium.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, magnus.damm@gmail.com,
        lethal@linux-sh.org, linux-sh@vger.kernel.org
References: <201108080031.26165.rjw@sisk.pl> <20110807.154137.1593570736451213760.davem@davemloft.net>
In-Reply-To: <20110807.154137.1593570736451213760.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108080119.35061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 08, 2011, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Mon, 8 Aug 2011 00:31:25 +0200
> 
> > Hi,
> > 
> > Unfortuately, your commit 1eb19a12bd2214cdcad5273d472b062a4ba97fa1
> > (lib/sha1: use the git implementation of SHA-1) causes one of my test
> > systems, which is an ARM shmobile Mackerel development boards, to crash
> > during boot (due to referencing invalid addresses AFAICS).
> > 
> > Please fix or revert.
> 
> It's already been fixed by removing the ARM specific SHA1 assembler,
> simply repull.

It works now, thanks!
