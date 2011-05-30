Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1E3Onq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:43:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1E3Ono (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:43:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Mon, 30 May 2011 16:43:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg KH" <greg@kroah.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105301604.38026.arnd@arndb.de> <2AF43CEDFDB649AE946E8F9F98A5AE48@subhasishg>
In-Reply-To: <2AF43CEDFDB649AE946E8F9F98A5AE48@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301643.35997.arnd@arndb.de>
X-Provags-ID: V02:K0:LZ9xnZENAHENDPcPTNDHf2LDeKDeb3EiuRAgz8GZMO6
 CYROBnc2nwJNOyNVuQCsJ4dGUVrcHXonHCR7f6jJ+Aj52fPFXN
 BCPkIM3BTEEWnnsPI5RO6EjLNksSV9NIk8GiLDF1qMXWGHvLRx
 Yfdy72WEZoMmvfzAAYuF7a2VFFRATkN7Yms2XQRtFwMN52kWE8
 JvkM9HsMvmz6v/eJ7Tx8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011, Subhasish Ghosh wrote:
> >
> > During the time when the drivers are in staging, all files need to
> > be in the same directory, including the header and the drivers using it.
> > They can get moved at the time when the driver gets turned into
> > a regular non-staging driver.
> 
> OK, so the UART implementation needs to be moved into staging as well ?
> 
> And what about the boardfile changes, array of mfd_cells implementation etc. 

All of that, too.

Note that you are citing exactly the points that are the reason for the
discussion we are having. The mfd_cells are the main concern for the cases
where the information is not static.

	Arnd
