Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab1JAUaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:30:14 -0400
Received: from nm28-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.22]:40638 "HELO
	nm28-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756094Ab1JAUaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:30:07 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 16:30:07 EDT
X-Yahoo-Newman-Id: 534577.94492.bm@smtp108.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KsyJeK4VM1nBVBpYU5Bq.5fYIznlRBpJX_03HkBpvSNZUDb
 1Nn6Q.siF3E8RoWOF74YouY21leFFiSzcCbgtU2UWKMzei1ug9qzMoajEeF5
 1NhlPeSpyOdSiCE6iLk0okTFRklYKvN2Vu6HOAh3ub.wxQHTR9EdBaFSLgHd
 Cbk_w8Q0E4et61pKJPzLA8_FVYBlCY1EoW6C5_WNmTYEojeLhifrnyE7nvYC
 3oljKqpYwDYpmJ01V1yziKmdwN8HEyekvz7SbNSuUBhPrHrYl.yn6hV5OZnC
 ZlQ7wCVQedcKRnbRAAoqasRHd36GsN8aeRTY.0s0t1eG_8O0Yteg0cMSAxG1
 2ahqGruPxXb9xLi6NEkvUEpC6LL2Bl8LMwUmyDkNB0LtRf_dYv_X65g.gWid
 0OwdeIUFdVSH2ZMkSwu86AikGfmCfnvtthEKijq379BrlD6AaqXA-
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Sat, 1 Oct 2011 15:24:40 -0500
From: Andy <akwatts@ymail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: schwab@linux-m68k.org, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001202440.GA14673@zeus>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
 <20111001171916.GA11989@zeus>
 <20111001175456.GC18690@1wt.eu>
 <20111001184044.GA13608@zeus>
 <20111001190612.GA14779@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001190612.GA14779@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:06:12PM +0200, Willy Tarreau wrote:
> OK I'm attaching two files, one computed with the initial 002 perms and
> a second one with the new 022 perms. I don't precisely know when the perms
> changed, hence the two files. I noticed that 2.6.25 was still 002, and that
> 2.6.32 was 022. In between I don't know. Note that I'm missing some tags
> (at least 2.6.35.12 and a few 2.6.33.x and 2.6.34.x).

Very helpful Willy, many thanks for doing this.

> It would be nice if someone with an access to a mirror could check the
> perms of *every* tarball so that we can establish the definitive list
> of signatures.

I agree, would be nice to fill in the few gaps.

~ Andy
