Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1DGJht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:37:49 -0400
Received: from mail.erfurth.eu ([89.107.64.155]:56676 "EHLO mail.erfurth.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab1DGJht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:37:49 -0400
Message-ID: <4D9D85E4.2040606@erfurth.eu>
Date: Thu, 07 Apr 2011 11:37:40 +0200
From: Nico Erfurth <ne@erfurth.eu>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Eric Cooper <ecc@cmu.edu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH 0/2] ARM: Unify setup for Marvell SheevaPlugs and Seagate
 DockStars
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <4D9CEE24.1080501@erfurth.eu> <4D9D81ED.7090809@ahsoftware.de>
In-Reply-To: <4D9D81ED.7090809@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Holler wrote:

> I wonder how many people believe that either there will be another
> DockStar with the same HW and GPIOs for the LEDs but more memory (and
> still without sata) or that there will be another SheevaPlug with just
> 128MB RAM or that someone could have a reason to change the memory
> layout using a mem= parameter.
> 
> For me all that is pretty unlikely.

As Nicolas stated it's not just about "Oh, thats totally unlikely to
happen!". It is about maintainable code, if somebody looks at it in 3
years they should not think "WTF?!?!". Using machine ids and the
generated macros helps to keep the code clean and readable.

Nico
