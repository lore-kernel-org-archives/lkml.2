Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0IHGSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:18:53 -0400
Received: from shamrock.taprogge.org ([213.146.117.139]:49977 "EHLO
	shamrock.taprogge.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab0IHGSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:18:51 -0400
Date: Tue, 7 Sep 2010 20:59:29 +0200
From: Jens Taprogge <jens.taprogge@taprogge.org>
To: Frank Becker <fb@alien8.de>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        alsa-devel@vger.kernel.org, bp@alien8.de
Subject: Re: commit 7b2bfdb broke sound card detection on my Lenovo T400s
Message-ID: <20100907185929.GA32126@taprogge.org>
References: <20100906170421.GA2957@alien8.de>
 <20100906224548.GA27279@taprogge.org>
 <s5hlj7ew0ph.wl%tiwai@suse.de>
 <20100907090220.GA3204@alien8.de>
 <s5h7hixap1c.wl%tiwai@suse.de>
 <20100907094041.GA2815@alien8.de>
 <s5h1v95anxg.wl%tiwai@suse.de>
 <20100907095300.GB2815@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907095300.GB2815@alien8.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.5 (--)
X-Spam-Report: Spam detection software, running on the system "shamrock.taprogge.org", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Tue, Sep 07, 2010 at 11:53:00AM +0200, Frank Becker wrote:
	> Takashi Iwai [2010-09-07, 11:44 +0200]: > > At Tue, 7 Sep 2010 11:40:41
	+0200, > > Frank Becker wrote: > > > > > > Takashi Iwai [2010-09-07, 11:20
	+0200]: > > > > At Tue, 7 Sep 2010 11:02:20 +0200, > > > > Frank Becker wrote:
	> > > > > > > > > > Takashi Iwai [2010-09-07, 08:17 +0200]: > > > > > > At
	Tue, 7 Sep 2010 00:45:48 +0200, > > > > > > Jens Taprogge wrote: > > > >
	> > > > > > > > > > On Mon, Sep 06, 2010 at 07:04:21PM +0200, Frank Becker
	wrote: > > Hi, > > [...] > > Oh, one forgotten question is whether your machine
	can have a docking > > station. If yes, model=thinkpad is the right choice.
	If not, > > model=ideapad would work more or less same. > Yes[0]. With that
	model (T400s [1]) Lenovo introduced a new series of docking > stations that
	are not backward compatible with older Lenovo/ThinkPads. > > I just don't
	happen to have one available. > > [0] http://shop.lenovo.com/SEUILibrary/controller/e/web/LenovoPortal/en_US/catalog.workflow:show-category-with-items?category-id=34851FD360E5473EB9DFEB639312E18E
	> > [1] http://shop.lenovo.com/SEUILibrary/controller/e/web/LenovoPortal/en_US/catalog.workflow:category.details?current-catalog-id=12F0696583E04D86B9B79B0FEC01C087&current-category-id=AEA4BB4495A04C098DBEA8EBB87059AC
	[...] 
	Content analysis details:   (-2.5 points, 10.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.9 TVD_RCVD_IP            TVD_RCVD_IP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 11:53:00AM +0200, Frank Becker wrote:
> Takashi Iwai [2010-09-07, 11:44 +0200]:
> > At Tue, 7 Sep 2010 11:40:41 +0200,
> > Frank Becker wrote:
> > > 
> > > Takashi Iwai [2010-09-07, 11:20 +0200]:
> > > > At Tue, 7 Sep 2010 11:02:20 +0200,
> > > > Frank Becker wrote:
> > > > > 
> > > > > Takashi Iwai [2010-09-07, 08:17 +0200]:
> > > > > > At Tue, 7 Sep 2010 00:45:48 +0200,
> > > > > > Jens Taprogge wrote:
> > > > > > > 
> > > > > > > On Mon, Sep 06, 2010 at 07:04:21PM +0200, Frank Becker wrote:
> 
> Hi,
> 
> [...]
> > Oh, one forgotten question is whether your machine can have a docking
> > station.  If yes, model=thinkpad is the right choice.  If not,
> > model=ideapad would work more or less same.
> Yes[0]. With that model (T400s [1]) Lenovo introduced a new series of docking
> stations that are not backward compatible with older Lenovo/ThinkPads.
> 
> I just don't happen to have one available.
> 
> [0] http://shop.lenovo.com/SEUILibrary/controller/e/web/LenovoPortal/en_US/catalog.workflow:show-category-with-items?category-id=34851FD360E5473EB9DFEB639312E18E
> 
> [1] http://shop.lenovo.com/SEUILibrary/controller/e/web/LenovoPortal/en_US/catalog.workflow:category.details?current-catalog-id=12F0696583E04D86B9B79B0FEC01C087&current-category-id=AEA4BB4495A04C098DBEA8EBB87059AC

Hello Frank.

That is the docking station I have developed the patch with.  So
hopefully after adding your PCI IDs it should work with your Thinkpad as
well.

Best Regards
Jens

