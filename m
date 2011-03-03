Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab1CCVHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:07:06 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:57652 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758Ab1CCVHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:07:03 -0500
Date: Thu, 3 Mar 2011 22:06:47 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110303210647.GA27691@nik-comp.lan>
References: <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6FFE5D.1030401@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4711626 records (last update: 20110303)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the exact kernel version you are using in the guest.
It's latest centos (2.6.18-194.32.1.el5), so I guess there are a lot
of fixes, but it's possible the kvm-clock is broken in it.
I can't influence what kernel is used there (at least not on customer's
guests), but I guess asking for adding clocksource kernel parameter is
not problem.


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
