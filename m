Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab0CSTvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:51:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0CSTve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:51:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mstsxfx@gmail.com>
Subject: Re: unable to handle kernel paging request on resume with 2.6.33-00001-gbaac35c
Date: Fri, 19 Mar 2010 20:54:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org
References: <20100301175256.GA4034@tiehlicka.suse.cz> <201003121840.13938.maciej.rutecki@gmail.com> <20100319152904.GB4090@tiehlicka.suse.cz>
In-Reply-To: <20100319152904.GB4090@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003192054.42011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 March 2010, Michal Hocko wrote:
> On Fri, Mar 12, 2010 at 06:40:13PM +0100, Maciej Rutecki wrote:
> > On poniedzia??ek, 1 marca 2010 o 18:52:57 Michal Hocko wrote:
> > > Hi,
> > > 
> > > I have experienced the following kernel BUG on resume from suspend from
> > > disk (the whole log from  hibarnation to suspend along with kernel
> > > config are attached):
> > > 
> > 
> > I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15526
> > for your bug report, please add your address to the CC list in there, thanks!
> 
> I haven't seen the same problem since I reported it but it seems that my
> laptop is slowly dying (I had several random hangs with no crash) so I
> guess that this is HW related.

Thanks for letting us know.

Rafael
