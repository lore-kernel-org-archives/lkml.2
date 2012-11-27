Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2K0QLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:11:53 -0500
Received: from tee.schottelius.org ([77.109.138.222]:40116 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755514Ab2K0QLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:11:52 -0500
Date: Tue, 27 Nov 2012 17:11:42 +0100
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        Valdis.Kletnieks@vt.edu, David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: [Jfs-discussion] Out of memory on 3.5 kernels
Message-ID: <20121127161142.GC5006@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>, Valdis.Kletnieks@vt.edu,
	David Rientjes <rientjes@google.com>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	jfs-discussion@lists.sourceforge.net
References: <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
 <20120926060653.GD16575@schottelius.org>
 <20120926085708.GA7839@schottelius.org>
 <20120927055208.GA25252@schottelius.org>
 <20121003212311.GA14018@schottelius.org>
 <22962.1349452084@turing-police.cc.vt.edu>
 <20121005175139.GC831@schottelius.org>
 <20121030103535.GA10526@schottelius.org>
 <50AD5791.5010702@oracle.com>
 <50B4E2CA.6060508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B4E2CA.6060508@oracle.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.6.6-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave,

Dave Kleikamp [Tue, Nov 27, 2012 at 09:56:58AM -0600]:
> [...] 
> I believe this commit will fix the problem:
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4eff96d
> 
> It is targeted for the stable kernels.

Thanks, I'll give it a try, I've v3.7-rc7-25-g2844a48 compiled already
and give the system a reboot this evening.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
