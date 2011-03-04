Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1CDWg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:36:56 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:45253 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759883Ab1CDWgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:36:55 -0500
Date: Fri, 4 Mar 2011 23:36:40 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Glauber Costa <glommer@redhat.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110304223640.GC2867@nik-comp.lan>
References: <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com> <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain> <20110304205512.GB2867@nik-comp.lan> <1299274906.11618.157.camel@mothafucka.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299274906.11618.157.camel@mothafucka.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4719961 records (last update: 20110304)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think although the long term plan is to just do this update once in
> your case (stable tsc), this update is needed. 
> 
> Why don't you send a patch to re-include it ?
> 
Yes, I'll gladly submit patch, one question, is this OK
to just add calling kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) before
the conditional (as I did in my test), or should it go somewhere to else {..}
section? it's called inside the conditional again, which will cause it
to be called twice in some cases, is it OK?
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
