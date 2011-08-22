Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1HVALX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:11:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37763 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab1HVALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:11:22 -0400
Date: Mon, 22 Aug 2011 02:11:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110822001121.GN25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com> <20110821231354.GL25996@one.firstfloor.org> <CACqU3MUAuMMC0c1Aesb3-oSzRXw4ddRYtjKDYovXewbCFL6dFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MUAuMMC0c1Aesb3-oSzRXw4ddRYtjKDYovXewbCFL6dFg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It does not work if / on a ROM, unless you start using trampoline
> partition, but this is starting to become really convoluted...

On a ROM you never change the kernel.

Besides who uses ROMs now when there is flash?

-Andi
