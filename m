Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0IGVr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:47:26 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34049 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0IGVrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=uNastSUnRlDPf9qm8L5VQUfdOdA6qsath+Mpou9k+mQ+UbF32mS7NAt3axr9oHDrwq
         ACGgqqBLTKUl3DhmfwRjjQSirntpPZ/b2nUCr3AZCiDr/43SpAiq19QYG/6Gp9QrdF/n
         E5y4vYHrax5brpHphxhkbIFZMMNnA8iiXVn24=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Subject: Re: 2.6.35.4: sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow
Date: Tue, 7 Sep 2010 22:47:18 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201009071834.27953.pedrogfrancisco@gmail.com> <20100907202143.02cf60ec@varda>
In-Reply-To: <20100907202143.02cf60ec@varda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009072247.18438.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010 19:21:43 Alejandro Riveira Fernández wrote:
> El Tue, 7 Sep 2010 18:34:27 +0100
> 
> Pedro Francisco <pedrogfrancisco@gmail.com> escribió:
> > sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow.
> > 
> > Now what I'm surprised is not the filesystem errors but me being allowed
> > to remove the module without using the '-f' option.
> > 
> > Do note, lsmod |grep ahci reports something like [this is adapted from a
> > 2.6.32 kernel]:
> > 
> > ahci                   32200  0
> > 
> > so it isn't at all surprising I'm being allowed to remove a seemingly
> > unused module. So....
> > a) is this supposed to happen?
> 
>  Yes afaics. root can do many stupid things if (s)he wants
>  including « rm -rf --no-preserve-root / »

That makes no sense. That's what the force option "-f" is for. It's my opinion 
the usage count for ahci on `lsmod' should be 1 and not 0. Whoever still wants 
to remove it can use the `rmmod -f ahci'


> 
> > b) do you need any more info?
> > 
> > P.S.: CC'ing me will probably ensure I'll reply faster but not explicitly
> > needed since I'm subscribed.


-- 
Pedro
