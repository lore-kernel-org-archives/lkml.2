Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2E0MI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 08:08:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2E0MIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 08:08:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH RFC] serial/8250: Adjusting FIFO parameters for LPC32xx
Date: Sun, 27 May 2012 12:07:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
References: <1338048678-23991-1-git-send-email-stigge@antcom.de> <201205271023.16742.arnd@arndb.de> <4FC21214.7060804@antcom.de>
In-Reply-To: <4FC21214.7060804@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205271207.36770.arnd@arndb.de>
X-Provags-ID: V02:K0:zKk+lkAHRUzFKUAQM9UA7BQWqNooAdQZ0kVvdZlUvoJ
 xCGyBCkdWItN5xL5wto5ALS35WcybQqIJmyfsSVWp+Yc4QDYcL
 37rAhoUlAix+uKurgRYGlx+OJNOq3XmQ+DXHsLbzPIWezF75/8
 nFe1iYGdLNlrHpGa6R6icPG84wt70s4H/+PzepH3eJP1PeBgtf
 FVHJmsAJyE8kzhXQiC61NcGnlrsAS7QIHwBDNSkCpcoIMiuGAM
 0UD3iSf7uO+/Vcp9ArWPb7YbQ944EYNXDPO2llU8Y41ppy2Nqb
 9/ku1aXN0C6WU+gIDtLzXNM3HicWnI6kJ/8M+XgYtvzsEVgHO9
 SHjQ3U+/re9K6+0+2XAw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2012, Roland Stigge wrote:
> > Actually some of the other entries are wrong, too. The ns8250 entry should
> > be i8250, and I guess the 16750 and 16850 were also not made by national.
> 
> But maybe we should keep the existing compatible strings because
> existing boards/bootloaders are providing them already?

Right, we should only add to the list. Any entry that's already used potentially
needs to stay in there as you say.

	Arnd
