Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0LOQC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:02:57 -0500
Received: from www.tglx.de ([62.245.132.106]:60674 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0LOQCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:02:55 -0500
Date: Wed, 15 Dec 2010 17:02:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D08E391.2090205@siemens.com>
Message-ID: <alpine.LFD.2.00.1012151658450.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6> <4D07F70A.30209@web.de> <alpine.LFD.2.00.1012151357030.12146@localhost6.localdomain6>
 <4D08CE44.6000407@siemens.com> <alpine.LFD.2.00.1012151633510.12146@localhost6.localdomain6> <4D08E391.2090205@siemens.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Jan Kiszka wrote:
> Am 15.12.2010 16:41, Thomas Gleixner wrote:
> > Talking about headache. Your solution above does not prevent that
> > scenario.
> > 
> >  CPU 0                  CPU 1
> > 		
> >  synchronize_irq();
> > 		        hard irq comes in sees shared and unmasks
> 
> Nope, IRQ_ONESHOT is already cleared at that point.

Errm ? It's set. Could you please stop to increase my confusion ? :)

