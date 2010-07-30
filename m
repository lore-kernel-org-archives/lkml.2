Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab0G3S5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:57:45 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:21444 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760292Ab0G3S5h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:57:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 476558.53123.bm@omp203.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3fVkWBV+mb6SWLTjCknxDMrQW1moOeMyWyPKTjUkOonsNM6JcYl9fCtsIrRp7Vyp8aUiWblWcmM/0K0/aS/m7i0dIfyznYMjR1e57cvgiYYttLHIBihXIRTXCLAeZ2f336AnujEm36CJQc9vUG+fR8G+dRsH7urpj0gPcpozqPo=;
Message-ID: <355626.7330.qm@web180313.mail.gq1.yahoo.com>
X-YMail-OSG: w_IiF3AVM1n038sLG2fRJ9rM.UPj_HFTNGvhqgRVqkRWkPf
 COzgR4h1P4LijoACw0LhAcRsidodH005lGDAp_48Vxq7vgop2rc4pEzaEAFb
 96b4ObTMPrC8Q6gOfG0H5HS9giDQ3T8.J9BMDVLXEF0.AAU_qmHC3RZd36QR
 X5vIzdI3MMD7fQRkntj24d1kjYkaNdstN1ro4JmlIZONiu7gXrzHS9CQhpi3
 HCa3i1n_zD.mF8cONbi6NQm7NbOZ23cy57L0IML50XqxkOsdBLDwYqv0m3Cd
 4xgfd4ixVVLULFoQAbu3W9_hxXCVwBKs6ZDPy9ao-
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Fri, 30 Jul 2010 11:57:35 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some gadgets
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>,
        Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <20100730165450.GA4943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>  We shouldn't be using _any_ netchip
> ids anymore now that we
> have our own vendor id assigned to us.

That's too extreme; the original handful of
NetChip IDs were (and are!!) correctly assigned,
and there's no reason to change them.  In fact,
there's a lot of reason to continue using them
while config files and drivers expect to see
those specific IDs (as is reasonable).  That's
to avoid breaking working configs...

For new IDs, yes:  use Linux-foundation VIDS/PIDs.

- Dave

