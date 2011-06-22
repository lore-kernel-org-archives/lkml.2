Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1FVGW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:22:28 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34769 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1FVGW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:22:26 -0400
Message-ID: <4E018A70.1060706@ahsoftware.de>
Date: Wed, 22 Jun 2011 08:23:44 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b13pre) Gecko/20110501 Thunderbird/3.3a3
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
References: <Pine.LNX.4.44L0.1106211054460.2327-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1106211636190.2142@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1106211636190.2142@xanadu.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 21.06.2011 22:41, Nicolas Pitre wrote:

> ... and also in this case, I was talking about proper use of the packed 
> attribute in general, not at all about a specific case.  I wanted to 
> provide a broader view to some people who expressed doubts and 
> misunderstanding in the hope that the archive could keep this knowledge 
> base available.
> 
> I apologize if that wasn't clear to you.

If you meant the abomination writing one, thanks, but I never expressed
doubts or misunderstandings.

I said doubts may arise because the standard (C99) doesn't say anything
about if or how structs are packed (or aligned).

Alexander
