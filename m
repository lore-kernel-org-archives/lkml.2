Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2GPTrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:47:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2GPTrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:47:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for ocp2scp
Date: Mon, 16 Jul 2012 19:47:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1340370942-23201-1-git-send-email-kishon@ti.com> <20120716081204.GI7955@arwen.pp.htv.fi> <CAAe_U6JMGP3jEkkd=vqpR5KTeOnY51AOcb65zqKRRa8MtnWjzQ@mail.gmail.com>
In-Reply-To: <CAAe_U6JMGP3jEkkd=vqpR5KTeOnY51AOcb65zqKRRa8MtnWjzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207161947.01751.arnd@arndb.de>
X-Provags-ID: V02:K0:6gsJvrbui/IfI90GdbCJbyB839hPRh7uT1m3G8ThqqK
 FzNUcepTYXEmycu/v/ZDFC8f3dwcgRN+w5z3SEqLz+Lzuf+Rxa
 WQ7T0vOwrHImpr8O9plWvGNRYHr4PFGt8SVuh9gpc7r29HXG3o
 4sIsf4iDPRm3zF1Bv8/5cSjas0MzanafecJdLT5rC76pSz9iBn
 P3ztV69J1yw5koMKRH6aT+9P11pApSm7BHNOL5G70Y6hz3GPA/
 5JZLguMlsxxnLI2hDw+DT3+9MWJIL8tVHeXOmAuQJKDulOukM5
 sExoZJrEMlfL3kFK7d8K2Fuuiq4Gmui4C5win1qjX2Eqt0ZgEh
 wk/vHnKj5j5dumi5xwtY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2012, ABRAHAM, KISHON VIJAY wrote:
> >>
> >> I think we should reconsider the idea of drivers/bus/ with a file per
> >> bus in there at least for new buses, but doing a new drivers/scp/
> >> would be ok for me if there is enough opposition against the idea
> >> of drivers/bus aggregating different buses.
> >
> > I don't mind either way. The fact is that this ocp-to-scp bridge is
> > really a TI/OMAP thing. Not sure it deserves a directory of its own.
> 
> Ok. Then I'll have a file in drivers/bus/ for ocp2scp driver.

Sounds good to me. I don't care if it's the only file in that directory.
We can point the next person to a bus with a single file to that directory
and let them add theirs.

	Arnd
