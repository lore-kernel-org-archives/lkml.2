Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab2F0STk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:19:40 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:45779 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab2F0STi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:19:38 -0400
X-ASG-Debug-ID: 1340821177-03d6a53dc417330001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Wed, 27 Jun 2012 14:19:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Frederik Himpe <fhimpe@telenet.be>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.5.0-rc4: kernel BUG at fs/btrfs/inode.c:3758!
Message-ID: <20120627181934.GA14033@localhost.localdomain>
X-ASG-Orig-Subj: Re: 3.5.0-rc4: kernel BUG at fs/btrfs/inode.c:3758!
References: <4FEB41CE.8070205@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FEB41CE.8070205@telenet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1340821177
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0009 1.0000 -2.0152
X-Barracuda-Spam-Score: -1.89
X-Barracuda-Spam-Status: No, SCORE=-1.89 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA717, CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.101092
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.00 BSF_SC0_SA717          Custom Rule BSF_SC0_SA717
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 11:24:30AM -0600, Frederik Himpe wrote:
> After an unclean shutdown, Linux 3.5-rc4 fails to mount one of my btrfs 
> file systems. This backtrace can be found in the logs:

Fix is in btrfs-next

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=summary

Thanks,

Josef 
