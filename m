Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1H0WRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 18:17:08 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49890 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751739Ab1H0WRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 18:17:03 -0400
Date: Sat, 27 Aug 2011 15:16:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>,
        Matthew Garrett <mjg@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: minor grammatical fixes to documentation
Message-Id: <20110827151657.0641a353.rdunlap@xenotime.net>
In-Reply-To: <20110825030654.GA6074@khazad-dum.debian.net>
References: <20110823151149.GA7495@bluemoon.ece.utexas.edu>
	<20110825030654.GA6074@khazad-dum.debian.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 00:06:54 -0300 Henrique de Moraes Holschuh wrote:

> On Tue, 23 Aug 2011, Kumar Appaiah wrote:
> > This commit adds minor grammatical fixes to the description of the
> > keys in the thinkpad-acpi documentation.
> > 
> > Signed-off-by: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Applied, thanks.

> > ---
> >  Documentation/laptops/thinkpad-acpi.txt |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
> > index 6181548..b73dcea 100644
> > --- a/Documentation/laptops/thinkpad-acpi.txt
> > +++ b/Documentation/laptops/thinkpad-acpi.txt
> > @@ -411,9 +411,9 @@ event	code	Key		Notes
> >  
> >  0x1004	0x03	FN+F4		Sleep button (ACPI sleep button
> >  				semantics, i.e. sleep-to-RAM).
> > -				It is always generate some kind
> > +				It always generates some kind
> >  				of event, either the hot key
> > -				event or a ACPI sleep button
> > +				event or an ACPI sleep button
> >  				event. The firmware may
> >  				refuse to generate further FN+F4
> >  				key presses until a S3 or S4 ACPI
> 
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
