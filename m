Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1KYI3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:29:16 -0500
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1063 "HELO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752216Ab1KYI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:29:15 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14290
Message-ID: <4ECF5213.20501@metafoo.de>
Date: Fri, 25 Nov 2011 09:30:11 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Hemanth V <hemanthv@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH 1/2] MISC: convert drivers/misc/* to use module_i2c_driver()
References: <1322194447.30842.0.camel@phoenix>
In-Reply-To: <1322194447.30842.0.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 05:14 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/misc/* to use the
> module_i2c_driver() macro which makes the code smaller and a bit
> simpler.
> 

I think we should wait with spi and i2c patches until the macro can actually
be found in respective subsystem tree. Or do you want these patches to go
through GregKH's driver-core tree?
