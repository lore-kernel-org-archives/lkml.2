Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0GROsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:48:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0GROsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:48:09 -0400
Date: Sun, 18 Jul 2010 16:48:02 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100718144802.GA6627@fancy-poultry.org>
References: <909896077.345011279054483129.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
 <95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:e0ST1lC+0WhpZUN0zvaTX69A+SlpsW447GC3neNvRlL
 YC1w4hDqbY1rTzIB7O+uR+gwEkWBgdn2rRQmHtKfWKnCoIX9hc
 h30a3mCo2dISJyi4vcKh1vgwRO2W+aBtxZxSkruygMzvCrTfnm
 oSFMVgqpfnWbKnGkGJNADEJqhZoiGoAct6d1faImwZbOPQK3QU
 pBKOHBklawsf6tw5m7Eqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.2010, Michal Schmidt wrote: 

> The chipset is 890FX. Motherboard Asus M4A89TD PRO/USB3.
> BIOS is the latest version: 0901 (05/17/2010 according to dmidecode)
 
 > I found another person reporting the same symptoms on
 > GIGABYTE GA-MA770T-UD3P AthlonXII 620 (4 cores) kernel 2.6.33.5
(Mandriva)
> (http://www.abclinuxu.cz/poradna/hardware/show/308799, in Czech)

I have exactly the same problem on my system.
Gigabyte GA-MA770-UD3 (Rev. 1.0), latest BIOS F9g, Phenom II X4 905e.

Will try your patch and report back.



