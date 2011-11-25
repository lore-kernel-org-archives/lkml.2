Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1KYKQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:16:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1KYKQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:16:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/2] MISC: convert drivers/misc/* to use module_i2c_driver()
Date: Fri, 25 Nov 2011 10:15:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Hemanth V <hemanthv@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        "Greg Kroah-Hartman" <greg@kroah.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Anatolij Gustschin <agust@denx.de>
References: <1322194447.30842.0.camel@phoenix> <4ECF5213.20501@metafoo.de>
In-Reply-To: <4ECF5213.20501@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251015.43439.arnd@arndb.de>
X-Provags-ID: V02:K0:4PswehPSqqNX5I+WriBfVPKBJE2Y9zYTTyRnphZ0pEK
 tvjgevNAkfedBy+K8k5oalPW1atsvbLgqekuFP20KO5u0cF/X3
 McFPt/rLXcouH974T+nOwdw5KyC7q/t7gM24iN6Y5PwlDUn95y
 LT7GPn4uoCbe+0C8VSbEiqrE2vDxp2OHgPNCmihRASptukohJZ
 zIh2ojyE0plFZQ//w4Zk72v08pgoVD5uutj7FmAmiVh/qets3d
 VFZ194tve2ICtcwqa9WPl3zHMWU19y1qNxw3VAkQc1g7+5oev2
 DTez6PNayIXp7p/KHNWo9vXsj4x7snk45+lL3zFBrEVi7XTEX8
 QUEYuz/cIzQFrqAf4x/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 November 2011, Lars-Peter Clausen wrote:
> On 11/25/2011 05:14 AM, Axel Lin wrote:
> > This patch converts the drivers in drivers/misc/* to use the
> > module_i2c_driver() macro which makes the code smaller and a bit
> > simpler.

Acked-by: Arnd Bergmann <arnd@arndb.de>

> I think we should wait with spi and i2c patches until the macro can actually
> be found in respective subsystem tree. Or do you want these patches to go
> through GregKH's driver-core tree?

Obviously it can only go in after the patches introducing the macros.
Since Greg owns both the char-misc and driver-core trees, there should
be no problem coordinating between the two.

	Arnd
