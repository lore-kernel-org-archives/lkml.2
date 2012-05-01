Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2EAPtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:49:33 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:63611 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab2EAPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:49:31 -0400
Date: Tue, 1 May 2012 17:49:27 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lautriv <admin@coldplug.net>,
        Jim Cromie <jim.cromie@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
Message-ID: <20120501154927.GR3157@wantstofly.org>
References: <20120427095842.GW3157@wantstofly.org>
 <CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com>
 <20120427101732.GX3157@wantstofly.org>
 <CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com>
 <CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com>
 <20120427185809.GZ3157@wantstofly.org>
 <CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com>
 <CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com>
 <20120501125102.GN3157@wantstofly.org>
 <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 03:54:49PM +0200, Sedat Dilek wrote:

> Some more concerns...
> Dunno, if [4] is really correct and how to use one and same device-id
> for 8363 ***and*** 8361P:
> ...
> { PCI_VDEVICE(MARVELL, 0x2a02), .driver_data = MWL8363, },

No, you'll have to add a MWL8361P to the enum, and add a
mwl8k_device_info table entry for that, and then add the PCI ID
table entry with the MWL8361P identifier.
