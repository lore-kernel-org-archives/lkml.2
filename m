Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2EBNMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:12:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2EBNMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:12:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 00/06] serial8250: DLL/DLM rework, Emma Mobile UART driver
Date: Wed, 2 May 2012 13:12:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-serial@vger.kernel.org, horms@verge.net.au, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        dan.j.williams@intel.com, alan@linux.intel.com
References: <20120502124642.30480.41373.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205021312.08308.arnd@arndb.de>
X-Provags-ID: V02:K0:pxXft/q7Pnl4unba2ezOtef8VqavPDAD7dbBm7hbQz8
 spP875OUlQCBH+21lY7jFAAR7SFYBznmpJJ0kJSLYxy7DtW4Sc
 e24F89Ak8UIkI9cWPW1YNBzDqH1wwju9BJ9xhD1463wbxN4gUr
 d61fhKA5Y7MDtm8aRoXUUka6Y6AMFCLcs8EcB3nrELULjTLwn6
 imRfVc7JKZrn+n/6yKK1ohQJ7AsKXSty+ikVs0odMgCKGj65Kg
 lJK4GiMO+ijdz9eXnGTSHb/qD3sxVvmK8zSM+GLlYDE3OZ/TBi
 PGidVKx6mWaJOVgJChJpfhq1INtFj8WvsX77/1CMBF+tr8d/Gb
 g5IeX9AMlDyrIeqnhzHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012, Magnus Damm wrote:
> serial8250: DLL/DLM rework, Emma Mobile UART driver
> 
> [PATCH 01/06] serial8250: Add dl_read()/dl_write() callbacks
> [PATCH 02/06] serial8250: Use dl_read()/dl_write() on Alchemy
> [PATCH 03/06] serial8250: Use dl_read()/dl_write() on RM9K
> [PATCH 04/06] serial8250: Clean up default map and dl code
> [PATCH 05/06] serial8250: Introduce serial8250_register_8250_port()
> [PATCH 06/06] serial8250-em: Add Emma Mobile UART driver
> 
> This series cleans up and adjusts the 8250 code base to allow
> hooking in a driver for the UART in Emma Mobile SoCs.
> 
> In short:
> - Patch 1-4 tie in 8250-specific dl_read()/dl_write() callbacks.
> - Patch 5 adds a new register function to use new callbacks.
> - Patch 6 adds a new driver that makes use of the above.
> 
> I'd be happy to rework the above patches if needed. The
> main challenge for Emma Mobile UART support is the non-
> standard offsets for DLL and DLM registers.
> 
> Note that there is no DT support included at this point,
> but it boils down to a 10 line change. The boot loader on
> my board does not do DT so I'd like to use kexec for DT
> development (as usual), but to use kexec I first need to
> get a non-DT kernel working. Which is basically this. =)
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Looks good,

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
