Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425Ab2FHH5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:57:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:57497 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760944Ab2FHH5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:57:06 -0400
Date: Fri, 8 Jun 2012 09:57:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Francois Romieu <romieu@fr.zoreil.com>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
In-Reply-To: <20120608023420.GD7191@redhat.com>
Message-ID: <alpine.LFD.2.02.1206080954440.3086@ionos>
References: <20120530214809.GA19223@redhat.com> <alpine.LFD.2.02.1205310938080.3231@ionos> <20120601225754.GA25281@electric-eye.fr.zoreil.com> <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com> <20120605231550.GA20981@electric-eye.fr.zoreil.com>
 <20120606014656.GA24870@redhat.com> <20120606054251.GA24467@electric-eye.fr.zoreil.com> <20120608023420.GD7191@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-397927920-1339142224=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-397927920-1339142224=:3086
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Thu, 7 Jun 2012, Dave Jones wrote:
> 
> The log is still huge though. (68M uncompressed) at
> http://www.codemonkey.org.uk/junk/r8169-trace.txt.xz

Following that URL gives me a nice picture.

This is somewhat embarrassing, isn¢t it? :)

Thanks,

	tglx
	  
--8323328-397927920-1339142224=:3086--
