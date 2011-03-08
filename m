Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1CHK3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:29:31 -0500
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:34707 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1CHK33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:29:29 -0500
Subject: Re: HP G6 hardware kernel boot issue > 2.6.37 cciss/hpsa
From: Jesper Dangaard Brouer <hawk@comx.dk>
To: Maximilian Attems <max@stro.at>
Cc: Michael Prokop <mika@debian.org>, "Marco d'Itri" <md@linux.it>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20110303124705.GA19471@stro.at>
References: <1299087769.4279.27.camel@firesoul.comx.local>
	 <20110303124705.GA19471@stro.at>
Content-Type: text/plain
Organization: ComX Networks A/S
Date: Tue, 08 Mar 2011 11:29:26 +0100
Message-Id: <1299580166.11985.11.camel@firesoul.comx.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2011-03-03 at 13:47 +0100, Maximilian Attems wrote:
> On Wed, 02 Mar 2011, Jesper Dangaard Brouer wrote:
> 
[...]
> please file proper Debian bug report with reportbug.
> we already have scripts dealing with such device changes.
> Had previously thought that the need of them was over after the
> libata change, but obviously you show the contrare.
> 
> So fire up reportbug and report against linux-2.6 with severity grave.

I finally succeeded filing a Debian bug-report (as Debians mail system
clamav kept categorizing me as malware... hmm)

 Debian bug number: 617256
 Link: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=617256
 Update the case via email: 617256@bugs.debian.org

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network Kernel Developer
  Cand. Scient Datalog / MSc.CS
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer


[...]
> > Keywords: driver CCISS, HPSA, HP DL G6, uuid, udev, mkinitramfs,
> > initramfs-tools, debian squeeze
More keywords:
 HP Smart Array P410i Controller / Smart Array G6 controllers
 /dev/cciss/ scsi



