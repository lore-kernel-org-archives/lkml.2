Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572Ab2DLTPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:15:19 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:39746 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2DLTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:15:17 -0400
Date: Thu, 12 Apr 2012 13:15:16 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Balbi, Felipe" <balbi@ti.com>, "Mohammed, Afzal" <afzal@ti.com>,
        Greg KH <greg@kroah.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
In-Reply-To: <4F87240F.6060902@ti.com>
Message-ID: <alpine.DEB.2.00.1204121304050.29473@utopia.booyaka.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com> <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com> <4F867A95.9030104@ti.com> <20120412131045.GB31384@kroah.com> <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
 <alpine.DEB.2.00.1204121053570.29473@utopia.booyaka.com> <4F87240F.6060902@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-619568094-1334258116=:29473"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-619568094-1334258116=:29473
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Beno=EEt,

On Thu, 12 Apr 2012, Cousson, Benoit wrote:

> The LPDDR2 spec does consider as well NVM (Non Volatile Memory), so I thi=
nk we
> should stick to driver/memory for EMIF.

Hmm good point!

> > So perhaps something like drivers/memory/dram/ for the SDRAM controller=
s,
> > and maybe drivers/memory/ for the GPMC?
>=20
> In fact Felipe was considering something else for that kind of general pu=
rpose
> bus driver like GMPC, C2C and LLI...
>=20
> ... But I do not remember the name :-)

It would be nice if we could separate IP blocks that can drive an Ethernet=
=20
controller or modem chip from the DRAM controllers; they are quite=20
different beasts from a common API standpoint.


- Paul
--155748971-619568094-1334258116=:29473--
