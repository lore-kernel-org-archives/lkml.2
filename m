Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0JTPq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:46:27 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:51634 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab0JTPq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:46:26 -0400
Date: Wed, 20 Oct 2010 16:46:40 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
        linux-net maillist <linux-net@vger.kernel.org>,
        e1000-devel list <e1000-devel@lists.sourceforge.net>,
        "nikola.ciprich@linuxbox.cz" <nikola.ciprich@linuxbox.cz>
Subject: Re: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Message-ID: <20101020144640.GA3009@pcnci.linuxbox.cz>
References: <20101014052242.GA8998@pcnci.linuxbox.cz>
 <EA929A9653AAE14F841771FB1DE5A1366027CEFF1C@rrsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1366027CEFF1C@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 3964741 records (last update: 20101020)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Emil,

I tried it now, I can still 100% reproduce with 2.6.36-rc7-git2, but
with 2.6.36-rc8-git5 it works OK. So it certainly got fixed in the meantime!
I'll therefore close the bug in BZ.

have a nice day!

best regards

nik


On Fri, Oct 15, 2010 at 10:58:15AM -0600, Tantilov, Emil S wrote:
> >-----Original Message-----
> >From: Nikola Ciprich [mailto:extmaillist@linuxbox.cz]
> >Sent: Wednesday, October 13, 2010 10:23 PM
> >To: Linux kernel list; linux-net maillist; e1000-devel list
> >Cc: nikola.ciprich@linuxbox.cz
> >Subject: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
> >
> >Hi,
> >when I try to boot 2.6.36-rc7-git2 on one of my machines, it crashes while
> >setting up the network.
> 
> Thanks for letting us know!
> 
> >The setup is quite complex, with bonding, lots of vlans and 3 intel
> >adapters (system is quad x86_64)
> 
> Could you provide more details about the exact setup and the sequence of 
> commands that lead to the crash? If you can narrow it down to the actual 
> command that caused the crash that would be very helpful.
> 
> Also - are you testing from Linus or net-next tree? If you are not using 
> net-next, could you give it a try and see if you can reproduce it there?
> 
> >
> >snip of lspci:
> >06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet
> >Controller (Copper) (rev 01)
> >06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet
> >Controller (Copper) (rev 01)
> >09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> >Connection
> 
> Could you provide the output of lspci -vvv and a kernel config?
> 
> Thanks,
> Emil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

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
