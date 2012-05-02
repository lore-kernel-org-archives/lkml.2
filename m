Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2EBCin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:38:43 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:61098 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab2EBCil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:38:41 -0400
Date: Wed, 2 May 2012 04:38:36 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Pat Erley <pat-lkml@erley.org>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lautriv <admin@coldplug.net>,
        Jim Cromie <jim.cromie@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
Message-ID: <20120502023836.GW3157@wantstofly.org>
References: <CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com>
 <20120427101732.GX3157@wantstofly.org>
 <CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com>
 <CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com>
 <20120427185809.GZ3157@wantstofly.org>
 <CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com>
 <CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com>
 <20120501125102.GN3157@wantstofly.org>
 <CA+icZUV=qtXwVxb+uvQJcsza0y+6k2LHJFFPnECY0M=QWBexaQ@mail.gmail.com>
 <4FA089F9.1020602@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA089F9.1020602@erley.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 09:12:25PM -0400, Pat Erley wrote:

> >--- a/drivers/net/wireless/mwl8k.c
> >+++ b/drivers/net/wireless/mwl8k.c
> >@@ -5225,6 +5225,7 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
> >  }
> >
> >  enum {
> >+	MWL8361P = 0,
> >  	MWL8363 = 0,
> >  	MWL8687,
> >  	MWL8366,
> 
> I'm not an expert, but isn't this giving both 8361P and 8363 the
> same values in the enum?

Yeah, this is broken.
