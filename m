Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab0LHCKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:10:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:25749 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab0LHCKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:10:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,313,1288594800"; 
   d="scan'208";a="634176598"
Date: Wed, 8 Dec 2010 10:08:44 +0800
From: Feng Tang <feng.tang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
Message-ID: <20101208100844.5ea77fc0@feng-i7>
In-Reply-To: <4CFEE3A2.2050908@kernel.org>
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com>
	<tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org>
	<4CFD226C.60308@kernel.org>
	<20101207133204.4d913c5a@feng-i7>
	<alpine.LFD.2.00.1012071654080.2653@localhost6.localdomain6>
	<4CFE8045.2030101@kernel.org>
	<alpine.LFD.2.00.1012072327000.2653@localhost6.localdomain6>
	<4CFEE2D3.6050107@kernel.org>
	<4CFEE3A2.2050908@kernel.org>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 09:47:14 +0800
Yinghai Lu <yinghai@kernel.org> wrote:

> >>
> > 
> > Maybe Feng could send you updated version with simpler function?
> > 
> 
> also I prefer to keep save_mp_irq() instead of changing it to
> mp_save_irq().

The reason I changed the name is many similar functions and global
variables' name in io_apic.c start with "mp_", also using "mp_save_irq()"
may indicate that this piece of code originates from MP parsing code :)

Thanks,
Feng

> 
> Thanks
> 
> 	Yinghai
