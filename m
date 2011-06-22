Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1FVNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:09:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64013 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:09:56 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <201106221505.32531.arnd@arndb.de>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <201106211620.02065.arnd@arndb.de> <BANLkTim1kN2f41Cfz70=g4a_+gPPrWDacA@mail.gmail.com>
 <201106221505.32531.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 22 Jun 2011 16:09:35 +0300
Message-ID: <BANLkTi=1LPxiQFUbsLG+Dp1c0P9p_Ew6xQ@mail.gmail.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 4:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Ok, I see. In that case I agree that using debugfs is fine, but I would
> recommend trying to use fewer macros and just open-coding the file
> operations for better readability.

Sure thing. It didn't end up saving much code eventually, too, so I'll
just remove it.
