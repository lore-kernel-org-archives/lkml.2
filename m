Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1E3OEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:04:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1E3OEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:04:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Mon, 30 May 2011 16:04:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg KH" <greg@kroah.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <20110524134338.GA13491@kroah.com> <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg>
In-Reply-To: <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301604.38026.arnd@arndb.de>
X-Provags-ID: V02:K0:yKOVlufh5fizoglQ16dGG1WhsYegtg47H4d+Z8z4UvD
 vUEAipQMTVC07LWwA8dbZg2Mdap0NG5y4v3QmbXwz9xOcph0G5
 fzWYfku/cGBac2jMCng6LvYjFHoz3xs4r1RhnUSBs76zpgcsV5
 1+jQd0Eu23pve/McGT8bNK32t7hJQmHwDjt0lBiutpieKwPCm8
 NIgIMH58UxNeVVjzceiBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011, Subhasish Ghosh wrote:
> > Ah, forgot the TODO on the list of rules, I'll have to add that next
> > time.
> > 
> How do I handle the headers. I have two header files in the
> include/linux/mfd.
> 
> Should I submit them as a separate patch into mfd.
> 
> These headers are also used by pruss uart implementation. 

During the time when the drivers are in staging, all files need to
be in the same directory, including the header and the drivers using it.
They can get moved at the time when the driver gets turned into
a regular non-staging driver.

	Arnd
