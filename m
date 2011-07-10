Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1GJTWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 15:22:43 -0400
Received: from nm20-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.115]:27160
	"HELO nm20-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756292Ab1GJTWl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 15:22:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 238177.38041.bm@omp1019.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LyfMeGC18GLMH8UERydxS+ORvQty6pqKNo9ro18BS/FWSWLutc11KnNq5Wo1f0KPE1AjQhA1bGZIAeifqC7m6wCYFPrbPakl2NFQHJmRqfYcOnL+MPvpDd2V9RJV1Up/67+gtCaHc+kQEpfjYPG1XfFXtCL4nAcWkxODDWALB3Q=;
X-YMail-OSG: SaraQ90VM1kf7YuJarjDN9q1N66RPhiNwOaTayCMH84M0.H
 MSpej8QidYnflwpbXMRjv2AmfRKHW15zUJzCPd1ODvK70EBFKJkVroynBUQi
 pYdDfo1.WoEBi8lSuj08lLwCyLFX56cbCnTfzZY9WmQvc6pAj_GC2KBdLLhA
 xtoYDwgSYRf9nVw.3rONDb.AQBvN0mRrd70lQas4Y5YiH7wEfNcFK9MZyfZu
 E4YQB0bZDyR0Ml.ZTqd4WvSg8BDgv5lLHpWWKfdFFTxpmydGaZDo_FHIaj8x
 dgOIyhbZoc0Y2XpUSOnYmQhBw.1V4lGHiyKbioC43uSB8k78Kj0t9133X5jX
 xhJTi_SrBIiZtuloQSa.3tUJpEPdYb0Wdhg02340q541eKc.06bNCR5xlBun
 m9rmlyzzU8ZF_Nc9BLEI6M_iXPzndBm01DvlH1mcr3VRzz_gIl7nbqTakVlu
 f
X-Mailer: YahooMailRC/572 YahooMailWebService/0.8.112.307740
References: <1310321566-29266-1-git-send-email-markpearson_de@yahoo.de> <20110710182634.GA19612@kroah.com>
Message-ID: <1310325760.12531.YahooMailRC@web26207.mail.ukl.yahoo.com>
Date: Sun, 10 Jul 2011 20:22:40 +0100 (BST)
From: Mark Pearson <markpearson_de@yahoo.de>
Subject: AW: [PATCH] Staging: comedi: Fixing style issues
To: Greg KH <greg@kroah.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110710182634.GA19612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Ursprüngliche Mail ----
> Von: Greg KH <greg@kroah.com>
> An: markpearson_de@yahoo.de
> CC: abbotti@mev.co.uk; fmhess@users.sourceforge.net; 
>devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Gesendet: Sonntag, den 10. Juli 2011, 20:26:34 Uhr
> Betreff: Re: [PATCH] Staging: comedi: Fixing style issues
> 
> On Sun, Jul 10, 2011 at 08:12:46PM +0200, markpearson_de@yahoo.de wrote:
> >  From: Mark Pearson <markpearson_de@yahoo.de>
> > 
> > comedi_fops.c : Warning that externs should be avoided in .c  files.
> >                 A forward  function decleration was declared extern
> >                  although it was only used internally.  Changed
> >                  decleration to static.
> > comedi.h      : Fixed warning that  storage class should be a the
> >                  begining of declerations.
> > 
> > Lindent ran on both  files.
> > 
> > Ignore previous patch - forgot to add signed off  by.
> 
> Care to break this up into a set of "only do one thing per  patch"
> series?  That way it's reviewable.
> 
> Also, running Lindent  is usually a very bad idea on files that have been
> around for a while  now.  It causes a lot of unneeded churn, please just
> make the minor  changes needed to be checkpatch.pl clean by hand.
> 
> thanks,
> 
> greg  k-h
>

No problem Greg. I've submitted the patches for the two files again as a 
one-thing-per-patch and left out the Lindent.

Thanks for the feedback.

Cheers, Mark.

