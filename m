Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1JBDbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 23:31:15 -0400
Received: from nm18-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.64]:31907 "HELO
	nm18-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750963Ab1JBDbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 23:31:08 -0400
X-Yahoo-Newman-Id: 717967.12016.bm@smtp113.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BAs_UTkVM1mJ9.s.GMXWhSA3hTQwhoZzeOXzvOK1oOy0Ny4
 COSzfmZYyQyos2yINYvIrPJMMVzWgftCcWDffuxw80HiFvYGGFG0zfxDT6Pd
 BYLETmj1uLH8MIHY3ZhRg.GXFZRNt_4cXdWU_pHjW06.Eil38cesxTzoXNps
 zfDuMs90uei1QhBO8nLmsYWcVdyBTl9p.eLYlgCWuXFqLYnYA_9c9gXE1_TJ
 yIvOrpVDh7bl28jNAn.0VTods9b_rYayTs.BWNVkhNBHmOd4LzB0dLaJCamQ
 N9XpToq5el_qVkGU5ZJTqDwTuCSfo9Cbjl3sK98jZ5XyWmYHWes5GD0JqQHk
 71mWqajaGVBZgIu49uIly5WZ0C31ljUwDw3CqL.XwRHQ9dhxV41EwYsKbFLm
 BwwckFP4hmz5zxKAPKNNZ0LXDnAZBo7GUqz5slJ9z
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Sat, 1 Oct 2011 22:30:58 -0500
From: Andy <akwatts@ymail.com>
To: Greg KH <greg@kroah.com>
Cc: tmhikaru@gmail.com, Willy Tarreau <w@1wt.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hpa@zytor.com
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111002033058.GA20166@zeus>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
 <20111001171916.GA11989@zeus>
 <20111001175456.GC18690@1wt.eu>
 <20111001184044.GA13608@zeus>
 <20111002022643.GA4076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002022643.GA4076@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 07:26:43PM -0700, Greg KH wrote:
> On Sat, Oct 01, 2011 at 09:58:38PM -0400, tmhikaru@gmail.com wrote:
> > 	Any way we could get something like this verification done for the
> > 3.0.x stable kernels?  I'm currently stuck without any way known to me to
> > verify that any of the patches I downloaded from kernel.org before it went
> > down are actually correct.
> 
> I already sent a signed copy of the 3.0.4 patch that applies on top of
> the 3.0 kernel to the linux-kernel mailing list a few days ago.
> 
> That should be fine for what you need right now, right?
> 
> greg k-h

Greg:

Would it be possible for you to build on the great work already done by
Willy and provide the signature's he missed (they cluster around the more
recent branches which happen to be the tarballs most likely to have been 
downloaded during the intrusion window).

Maybe it makes sense to generate sha-256 fingerprints, as H. Peter says,
rather than the less collision-resistant md5.

Very few people probably have as complete a local git repo as you do.

~ Andy

