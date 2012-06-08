Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab2FHOXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab2FHOXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:23:49 -0400
Date: Fri, 8 Jun 2012 10:23:33 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120608142333.GB1711@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Marc Dionne <marc.c.dionne@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120530214809.GA19223@redhat.com>
 <alpine.LFD.2.02.1205310938080.3231@ionos>
 <20120601225754.GA25281@electric-eye.fr.zoreil.com>
 <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
 <20120605231550.GA20981@electric-eye.fr.zoreil.com>
 <20120606014656.GA24870@redhat.com>
 <20120606054251.GA24467@electric-eye.fr.zoreil.com>
 <20120608023420.GD7191@redhat.com>
 <alpine.LFD.2.02.1206080954440.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1206080954440.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 09:57:03AM +0200, Thomas Gleixner wrote:
 > On Thu, 7 Jun 2012, Dave Jones wrote:
 > > 
 > > The log is still huge though. (68M uncompressed) at
 > > http://www.codemonkey.org.uk/junk/r8169-trace.txt.xz
 > 
 > Following that URL gives me a nice picture.
 > 
 > This is somewhat embarrassing, isn’t it? :)

indeed ;-) Should be fixed.

	Dave

