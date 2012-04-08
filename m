Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2DHKYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 06:24:50 -0400
Received: from antcom.de ([188.40.178.216]:48567 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab2DHKYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 06:24:49 -0400
Message-ID: <4F816772.5000607@antcom.de>
Date: Sun, 08 Apr 2012 12:24:50 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Device tree conversion of spi device vs. controller_data
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

upon DT conversion of LPC32xx, I came across the at25 spi eeprom which
needs .controller_data in struct spi_board_info for slave registration
via spi_register_board_info() (non-DT-case).

In the DT case, we need to eliminate this explicit registering call.
Therefore, I need to somehow replace the .controller_data passing in the
DT case to pass this data to the spi core. But I can't find such a
mechanism (v3.4-rc2). Is there already a concept or API that I
overlooked (please just point me to it) or what can I do to solve this?
(Looks like a general issue for spi slave registration via DT).

Thanks in advance,

Roland
