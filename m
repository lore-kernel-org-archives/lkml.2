Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab1AMOzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:55:37 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:43837 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab1AMOzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:55:35 -0500
Date: Thu, 13 Jan 2011 15:51:59 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
Subject: Re: [Cluster-devel] 2.6.37 - GFS2 trouble
Message-ID: <20110113145159.GA13573@pcnci.linuxbox.cz>
References: <20110109210642.GG2400@nik-comp.lan> <1294650398.2450.3.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294650398.2450.3.camel@dolmen>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4377529 records (last update: 20110113)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quotad is often the first victim of any slow down or problem on GFS2
> since it runs periodically (even if you are not using quotas, it also
> looks after statfs too).
> 
> So I can't tell directly from that information what is wrong. I'd
> suggest taking glock dumps (via debugfs) as a first step. Grabbing
> backtraces of the glock_workqueue and other processes using gfs2 is
> probably the next step, and if that fails to point the way, the gfs2
> tracepoints are the next thing to look at,
Hello Steven,
Thanks a lot for Your reply and sorry for mine late one. I haven't been able 
to reproduce the problem yet, now I'm running 2.6.37 without problems.
When it happens again, I'll dump locks and report again.
Have a nice day!
nik.


> 
> Steve.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
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
