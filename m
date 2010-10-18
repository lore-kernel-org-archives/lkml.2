Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0JRGMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:12:35 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:35986 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0JRGMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:12:34 -0400
Date: Mon, 18 Oct 2010 08:12:20 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
        linux-net maillist <linux-net@vger.kernel.org>,
        e1000-devel list <e1000-devel@lists.sourceforge.net>,
        "nikola.ciprich@linuxbox.cz" <nikola.ciprich@linuxbox.cz>
Subject: Re: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Message-ID: <20101018061220.GB10146@pcnci.linuxbox.cz>
References: <20101014052242.GA8998@pcnci.linuxbox.cz>
 <EA929A9653AAE14F841771FB1DE5A1366027CEFF1C@rrsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1366027CEFF1C@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 3958493 records (last update: 20101018)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you provide more details about the exact setup and the sequence of 
> commands that lead to the crash? If you can narrow it down to the actual 
> command that caused the crash that would be very helpful.
> 
> Also - are you testing from Linus or net-next tree? If you are not using 
> net-next, could you give it a try and see if you can reproduce it there?
> 
> Thanks,
> Emil
Hello Emil,
sure, I'll gladly provide all the required data. I'll prepare it during Wednesday,
sorry I can't do it sooner.
in the meantime, Rafael created bugzilla entry, here's the link for the reference:

https://bugzilla.kernel.org/show_bug.cgi?id=20462

have a nice day
BR
nik


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
