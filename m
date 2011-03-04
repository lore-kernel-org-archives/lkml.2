Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab1CDS1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:27:50 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:42710 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463Ab1CDS1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:27:48 -0500
Date: Fri, 4 Mar 2011 19:27:33 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110304182733.GA2867@nik-comp.lan>
References: <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7101AF.6060009@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4717492 records (last update: 20110304)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Zachary,

> You don't see any messages about TSC being unstable or switching  
> clocksource after loading the KVM module?  And you are not suspending  
> the host or anything?
no messages, no suspending, nothing.


> Can you try using "processor.max_cstate=1" on the host as a kernel  
> parameter and see if it makes a difference?
I tried it, no change..
n.


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
