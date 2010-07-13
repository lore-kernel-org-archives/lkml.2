Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0GMVCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:02:08 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34129 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753237Ab0GMVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:02:06 -0400
Date: Tue, 13 Jul 2010 17:01:57 -0400 (EDT)
From: Michal Schmidt <mschmidt@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <95386209.346271279054917131.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <909896077.345011279054483129.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Borislav Petkov" <borislav.petkov@amd.com> wrote:
> ... and this is strange, I didn't experience anything like that on
> our X6 boxes here couple of months ago. But maybe something got changed
> in later kernels to trigger that behavior. Michal, what chipset is that
> and do you have the latest BIOS on it?

The chipset is 890FX. Motherboard Asus M4A89TD PRO/USB3.
BIOS is the latest version: 0901 (05/17/2010 according to dmidecode)

I found another person reporting the same symptoms on
GIGABYTE GA-MA770T-UD3P AthlonXII 620 (4 cores) kernel 2.6.33.5 (Mandriva)
(http://www.abclinuxu.cz/poradna/hardware/show/308799, in Czech)

Michal
