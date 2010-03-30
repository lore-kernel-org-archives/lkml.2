Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0C3Wu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:50:27 -0400
Received: from web94908.mail.in2.yahoo.com ([203.104.17.164]:36413 "HELO
	web94908.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753236Ab0C3WuZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:50:25 -0400
Message-ID: <999484.97147.qm@web94908.mail.in2.yahoo.com>
X-YMail-OSG: 2.0Rw_AVM1lz7k.XPtyQScbceL1KswI1hsK0vTSly0npZdr
 PGW9zIgX68a3WjE1l63FE1f8lDCwW_iOhR0jeGSli7Qo5HGN4xy.bWbyWJZB
 IvR19IaTB0RIQ4RguLZFv5hDz5Fd_Hwg.LAF2YqqLBV8VMJnhVOhnFaJxsiG
 QHlkW8cYOMF3ReWoVx1SLB4c3ejSg2Bhian4mguRHJEYwBwEVkm.9wUrZFsH
 PrwtPrXeWkFIUPFQL6L2PkMuQIGbPSTv4VFhcXmggtBizhwPYT0pL2cRe4MJ
 QE5fBp.rNSjR4OUVXWzfb6bY-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 31 Mar 2010 04:20:22 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: gregkh@suse.de
Cc: Marcel Holtmann <marcel@holtmann.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 31/3/10, Pavan Savoy <pavan_savoy@ti.com> wrote:

> From: Pavan Savoy <pavan_savoy@ti.com>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: gregkh@suse.de
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, alan@lxorguk.ukuu.org.uk
> Date: Wednesday, 31 March, 2010, 4:11 AM
> --- On Wed, 31/3/10, Pavan Savoy
> <pavan_savoy@yahoo.co.in>
> wrote:
> 
> > From: Pavan Savoy <pavan_savoy@yahoo.co.in>
> > Subject: Re: [PATCH] drivers:staging: sources for ST
> core
> > To: "pavan_savoy@yahoo.co.in"
> <pavan_savoy@yahoo.co.in>
> > Date: Wednesday, 31 March, 2010, 4:06 AM
> > > From: Greg KH [gregkh@suse.de]
> > > Sent: Wednesday, March 31, 2010 3:17 AM
> > > To: Savoy, Pavan
> > > Cc: Alan Cox; marcel@holtmann.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] drivers:staging: sources for
> ST
> > core
> > > 
> > > On Wed, Mar 31, 2010 at 02:35:55AM +0530, Pavan
> Savoy
> > > wrote:
> > > > So, something like the below is ok, I have
> > defined my
> > > own pr_fmt,
> > > > however default log level on my board is 7,
> and
> > hence
> > > pr_info is a bit
> > > > more annoying than usual.
> > > 
> > > No, a driver should use dev_dbg() and other
> > dev_printk()
> > > calls, not
> > > pr_debug() or anything like that.
> > > 
> > > Please don't roll your own formats, use the ones
> that
> > are
> > > well defined
> > > and uniquely describe your driver and device in
> a
> > format
> > > that the whole
> > > kernel uses.
> > 
> 

forgot lkml the last time..

Nope, I couldn't find any instance of struct device at all,
I need that to use dev_dbg right ? - None of the tty_*
structure accessible by ldiscs seems to have a reference to
it.
Also I happened to look at other line discipline driver, if
they have a smarter way of doing this, Nope - n_tty, n_hdlc,
n_slip all seem to use plain old printks.
 
Any clues ??


> > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 
> >       Your Mail works best with the New
> > Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
> > 
> 
> 
>       Your Mail works best with the New
> Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
