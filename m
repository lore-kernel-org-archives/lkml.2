Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243Ab2HJWep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:34:45 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:59358 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab2HJWen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:34:43 -0400
Date: Sat, 11 Aug 2012 00:34:26 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Roland Dreier <roland@kernel.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: mellanox mlx4_core and SR-IOV
Message-ID: <20120810223426.GV11089@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
 <CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
 <CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
 <20120801205640.GN5470@ics.muni.cz>
 <CAE9FiQWmgyirjjCwn54PkAsfvWxZSY5RhRVDkhhbK7E0NPzqaw@mail.gmail.com>
 <20120801220802.GP5470@ics.muni.cz>
 <CAE9FiQW84gjtX=_4guCBgcAJmkAGQ5ooFoj7C_29K7QK0s9qwA@mail.gmail.com>
 <20120803083344.GF25979@ics.muni.cz>
 <50255849.6070307@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50255849.6070307@genband.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 94.112.253.31
X-Muni-Envelope-From: xhejtman@ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 11 Aug 2012 00:34:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 12:51:53PM -0600, Chris Friesen wrote:
> On 08/03/2012 02:33 AM, Lukas Hejtmanek wrote:
> >I also tried OFED package from Mellanox which seems to have better SR-IOV
> >support (at least mlx4_ib does not complain that SR-IOV is not supported).
> >However, it does not work when SR-IOV enabled:
> 
> Last I heard they were not officially providing support for SR-IOV.
> Has anyone heard otherwise from the Mellanox folks?

they speak about it for 2 years:
http://www.openfabrics.org/archives/spring2010sonoma/Monday/1.30%20Liran%20Liss%20I%3FO%20Virtualization/sriov_liss.ppt

these are modified OFED drivers which seem to contain SR-IOV code also for IB
layer.
http://www.mellanox.com/content/pages.php?pg=products_dyn&product_family=26&menu_section=34#tab-three

-- 
Luká¹ Hejtmánek
