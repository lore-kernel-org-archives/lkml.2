Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2DMD3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 23:29:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab2DMD3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 23:29:48 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Device tree conversion of spi device vs. controller_data
To: Roland Stigge <stigge@antcom.de>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4F816772.5000607@antcom.de>
References: <4F816772.5000607@antcom.de>
Date: Thu, 12 Apr 2012 21:29:44 -0600
Message-Id: <20120413032945.0C76B3E07AC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Apr 2012 12:24:50 +0200, Roland Stigge <stigge@antcom.de> wrote:
> Hi,
> 
> upon DT conversion of LPC32xx, I came across the at25 spi eeprom which
> needs .controller_data in struct spi_board_info for slave registration
> via spi_register_board_info() (non-DT-case).
> 
> In the DT case, we need to eliminate this explicit registering call.
> Therefore, I need to somehow replace the .controller_data passing in the
> DT case to pass this data to the spi core. But I can't find such a
> mechanism (v3.4-rc2). Is there already a concept or API that I
> overlooked (please just point me to it) or what can I do to solve this?
> (Looks like a general issue for spi slave registration via DT).

Can you point me at specific code?

.controller_data is owned by the spi_master driver.  The eeprom driver
shouldn't be accessing it directly at all; but I'll need to look at
specific code to really understand what is going on.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
