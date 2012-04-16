Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2DPNnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:43:52 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34869 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2DPNnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:43:51 -0400
Date: Mon, 16 Apr 2012 15:43:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, tigran@aivazian.fsnet.co.uk,
        hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
Message-ID: <20120416134335.GD308@aftab>
References: <20120411163849.GE4794@alberich.amd.com>
 <20120411200601.GC12288@kroah.com>
 <20120411201053.GF18114@aftab>
 <20120412162351.GJ24549@aftab>
 <20120412163422.GM24549@aftab>
 <4F8BDB58.6070007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8BDB58.6070007@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 02:12:00PM +0530, Srivatsa S. Bhat wrote:
> I guess a similar change in intel microcode driver would also be
> worthwhile, right? If so, then the below patch might be useful:

AFAICT, you'd need to test this on a box which is not supported (family
check below). Or you can tweak the family check so that it doesn't
apply and run it on a test box of yours to see whether the module still
unloads properly in the error case (and doesn't remain loaded as in
our case due to something in sysfs remaining registered although it
shouldn't).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
