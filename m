Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1CEI60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:58:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58431 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1CEI6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=xJ+T93dSp4qrWy8MGnb+tBt9nWbvHXhL/8Tb5WbyxjMVKQC8sDjFJ/aAivORJ/+Bbw
         30QOyCvHdVdpr/NLzyV5cr/Qq/DPOyqR9V9Ax1WtzqeVny/vVmo+3wi4U2L7zELthb07
         XKaA/L2/tXs8/LDefE36fQKVwuEZK6xCb6Zn0=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: File/memory corruption in 2.6.37?
Date: Sat, 5 Mar 2011 09:58:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: thomas@fjellstrom.ca, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
References: <201102251457.51476.thomas@fjellstrom.ca> <201102251531.00363.thomas@fjellstrom.ca> <20110302155226.05fbe993.akpm@linux-foundation.org>
In-Reply-To: <20110302155226.05fbe993.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103050958.22167.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 3 mars 2011 00:52:26, Andrew Morton a écrit :
> On Fri, 25 Feb 2011 15:31:00 -0700
> 
> Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> > On February 25, 2011, Thomas Gleixner wrote:
> > > On Fri, 25 Feb 2011, Thomas Fjellstrom wrote:
> > > > On February 25, 2011, you wrote:
> > > > > Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder
> > > > > indexes are being corrupted fairly regularly. Far more often than
> > > > > is usual (almost never). Several a day in fact are being
> > > > > corrupted. I can only imagine that this isn't the only corruption
> > > > > happening and it is worrying.
> > > > 
> > > > Forgot to give any kind of useful info:
> > > > 
> > > > System: Lenovo SL500 laptop, intel core2duo T9400 cpu, 4G ram, gm45
> > > > intel gfx
> > > > 
> > > > running debian sid, with the current debian 2.6.37 kernel, was
> > > > running a hand rolled 2.6.36 kernel with autogroup applied and
> > > > didn't have these issues.
> > > 
> > > Could you verify that with an hand rolled 2.6.37.2 ?
> > > 
> > > Thanks,
> > > 
> > > 	tglx
> > 
> > I suppose it won't hurt to give it a try.
> 
> Any results yet?
> 
> Which filesystem is being used?  I've seen at least one similar report
> for reiserfs.

Yes in my case kmail+git over reiserfs eat my data quite fast

That is really strange is a simple shell loop : while true; do sync; sleep 1; done; reduce the problem.

Bastien
 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
