Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab0JGJgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:36:19 -0400
Received: from mng.lbox.cz ([195.144.125.184]:49701 "EHLO mng.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab0JGJgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:36:17 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 05:36:17 EDT
Date: Thu, 7 Oct 2010 11:25:29 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, cluster-devel@redhat.com,
        Joel Becker <joel.becker@oracle.com>
Subject: Re: [Cluster-devel] 2.6.36-rc6-git4 - dlm/lockfs - general
 protection fault
Message-ID: <20101007092528.GA6673@develbox.linuxbox.cz>
References: <20101006085052.GA3736@develbox.linuxbox.cz>
 <1286357641.2696.4.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286357641.2696.4.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4056651 records (last update: 20101006)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like a configfs issue (copying in the maintainer), and since
> it is rmdir, I'm guessing that this is during dlm lockspace removal. It
> doesn't look from the trace as if it has got as far as the dlm code at
> the point at which the problem occurs,
> 
> Steve.

Hello Steve and thanks for the reply. Thanks, even though I've already
had joel CCed ;)
I wonder whether I should create bugzilla entry and if yes, where?
Since it's certainly configfs problem and it doesn't have it's own
bugzilla, maybe I should use kernel bugzilla?
nik



>  
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
