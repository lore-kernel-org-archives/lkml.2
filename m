Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2H0PWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:22:02 -0400
Received: from mail.x86-64.org ([217.9.48.20]:60037 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab2H0PV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:21:58 -0400
Date: Mon, 27 Aug 2012 17:21:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20120827152145.GH27979@aftab.osrc.amd.com>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
 <20120827112512.10313.49176.stgit@localhost.localdomain>
 <20120827144829.GF27979@aftab.osrc.amd.com>
 <503B8E26.2050604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503B8E26.2050604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 08:41:34PM +0530, Naveen N. Rao wrote:
> >Why not do a printk_once saying something along the lines of "BIOS
> >hasn't setup thresholds properly, correcting..." and that's it?
> 
> Yes, that's the intent here. I am using printk_once() and if I'm not
> mistaken, we print the above only once during boot.

Oh yes, you are. I need to clean my glasses. 8-) Sorry.

> I am open to changing the message if the above two lines aren't good.

Let's see what Tony has to say.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
