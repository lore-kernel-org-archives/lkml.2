Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0L3OqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 09:46:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0L3OqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 09:46:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [Bug #25442] ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver
Date: Thu, 30 Dec 2010 15:45:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Ben Hutchings" <ben@decadent.org.uk>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.CqE.K-7GNB@chimera> <m3zkrnv1x9.fsf@intrepid.localdomain>
In-Reply-To: <m3zkrnv1x9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301545.15667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 30, 2010, Krzysztof Halasa wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25442
> > Subject		: ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver
> 
> This FREQ has been there for years. Not that it makes it smart, and
> I'll obviously send Ben's patch upstream for 2.6.38. Still processing
> incoming mail queue :-(

Well, the patch is in the mainline, which is why it's still listed.

Thanks,
Rafael
