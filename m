Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768518Ab2KOQsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:48:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34208 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768411Ab2KOQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:48:39 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v6 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and use function pointers for getreg and setreg functions
References: <1352994659-22392-1-git-send-email-andreas@gaisler.com>
	<1352994659-22392-3-git-send-email-andreas@gaisler.com>
Date: Thu, 15 Nov 2012 17:38:31 +0100
In-Reply-To: <1352994659-22392-3-git-send-email-andreas@gaisler.com> (Andreas
	Larsson's message of "Thu, 15 Nov 2012 16:50:59 +0100")
Message-ID: <87y5i23jp4.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

 Andreas> The registers in the GRLIB port of the controller are 32-bit
 Andreas> and in big endian byte order. The PRELOW and PREHIGH registers
 Andreas> are merged into one register. The subsequent registers have
 Andreas> their offset decreased accordingly. Hence the register access
 Andreas> needs to be handled in a non-standard manner using custom
 Andreas> getreg and setreg functions.

 Andreas> Add setreg and getreg functions for different register widths
 Andreas> and let oc_setreg and oc_getreg use function pointers to call
 Andreas> the appropriate functions.

 Andreas> A type is added as the data of the of match table entries. A
 Andreas> new entry with a different compatible string is added to the
 Andreas> table. The type of that entry triggers usage of the custom
 Andreas> grlib functions by setting the setreg and getreg function
 Andreas> pointers.

 Andreas> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

Thanks!

-- 
Bye, Peter Korsgaard
