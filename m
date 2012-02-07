Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2BGGcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:32:07 -0500
Received: from adamg.eu ([91.192.224.99]:59356 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2BGGcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:32:05 -0500
X-Greylist: delayed 1989 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Feb 2012 01:32:05 EST
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arekm@pld-linux.org
Subject: Re: [3.2.2] tasks blocked during matrix auto checking.
Date: Tue, 07 Feb 2012 06:58:39 +0100
Message-ID: <4142598.MA7Zy4QWhf@vmx>
User-Agent: KMail/4.8.0 (Linux/3.2.2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120207094751.51e5321a@notabene.brown>
References: <2156863.jdbU24e2Kr@pawels> <20120207094751.51e5321a@notabene.brown>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of February 2012 09:47:51 NeilBrown wrote:
> On Mon, 06 Feb 2012 13:02 +0100 Pawel Sikora <pawel.sikora@agmk.net> wrote:
> 
> > Hi,
> > 
> > on heavy loaded opterons i've noticed some blocked tasks during matrix auto checking.
> > is it a known issue?
> 
> No.... maybe not too surprising though.
> The data-check will pause to let other IO through, but if there is lots of IO
> queued up it could cause some longish delays...
> 
> 2 minutes does seem a bit long though, so maybe there is a bug somewhere. 
> 
> And had 3 consecutive timeouts, so that makes it 6 minutes which really is
> too long.
> 
> What sort of array was this?  RAID1? RAID5 ??

~810GB in raid-10:

md2 : active raid10 sda4[0] sdd4[3] sdc4[2] sdb4[1]
      849514496 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]

