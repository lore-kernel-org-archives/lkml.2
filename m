Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1IPKJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:09:37 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40623 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1IPKJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:09:35 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 147.83.37.68
From: "Leopold Palomo-Avellaneda" <leo@alaxarxa.net>
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that disables EPP support on many chipsets
Date: Fri, 16 Sep 2011 12:09:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: Adam Baker <linux@baker-net.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
References: <201109151441.15015.leo@alaxarxa.net> <201109152123.07678.linux@baker-net.org.uk> <20110915203530.GA31345@elie>
In-Reply-To: <20110915203530.GA31345@elie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161209.29187.leo@alaxarxa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Dijous, 15 de setembre de 2011, Jonathan Nieder va escriure:
> Adam Baker wrote:
> 
> > The code has sat around for a long time because when I first posted the 
patch 
> > I got no feedback to indicate if anyone else was suffering from the bug 
and if 
> > anyone else had hardware that exhibited the bug it was supposed to fix so 
I 
> > didn't want to pursue submitting it. Over the years I have seen occasional 
> > reports of users suffering from the problem but I no longer have any EPP 
> > hardware to test it on.
> >
> > That's why I posted the mail that said if someone else can verify the 
patch is 
> > still useful I'm happy for it to be submitted with my signed off by on it
> 
> Makes sense.  Thanks for explaining and thanks for your work, Adam.
> Actually I think 3 years before a patch gets the attention it deserves
> is not so bad --- it was mostly that the problem has been known since
> 1999 that bothered me. :)
> 

Well, 

seems that the questions be clarified. I would like to point some details. 
First of all I would like to say that I didn't make this patch. It was done by 
Adam Baker, as I have posted in all the mails with the link to the original 
post.

I put a bug report the the debian bug tracking system [1] with a copy to the  
linux-parport list. The debian guys ( Jonathan Nieder) proposed me to send 
this patch directly to the linux kernel system.

I have send this patch as I could, maybe I didn't pay so attention as I must. 
I send the patch because Adam Baker said:

<quote>
As the parport driver is currently orphaned you need to post a patch to the 
LKML if you want to get it included in mainline but if your prepared to do 
some testing that would be the best solution for everyone.
</quote>

I submitted the patch because it seemed impolite to ask Adam Baker that he did 
it. In the end it was I who had interest in it to be included in the kernel 
tree.

And as I was who had to answer the mails of the kernel list and make the whole 
procedure of the kernel patches, so I signed it. 

To me is perfect that this patch goes to the kernel and I could answer any 
question of it, or make any test. I have several Dell boxes and a PCI with an 
extra parport.

Best regards,

Leo

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=630593
-- 
--
Linux User 152692
Catalonia
