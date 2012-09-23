Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2IWSod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 14:44:33 -0400
Received: from host2.bln.innominate.com ([77.245.32.75]:59680 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2IWSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 14:44:32 -0400
Date: Sun, 23 Sep 2012 20:44:30 +0200
From: Lutz Jaenicke <ljaenicke@innominate.com>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lxt PHY: Support for the buggy LXT973 rev A2
Message-ID: <20120923184430.GA29119@lutz.bln.innominate.local>
Mail-Followup-To: leroy christophe <christophe.leroy@c-s.fr>,
	David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <201209101545.q8AFjn7u021483@localhost.localdomain>
 <20120910181747.GA5960@lutz.bln.innominate.local>
 <505DE592.8060103@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <505DE592.8060103@c-s.fr>
Organization: Innominate Security Technologies AG
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 06:21:38PM +0200, leroy christophe wrote:
> 
> Le 10/09/2012 20:17, Lutz Jaenicke a écrit :
> >On Mon, Sep 10, 2012 at 05:45:49PM +0200, Christophe Leroy wrote:
> >>This patch adds proper handling of the buggy revision A2 of LXT973 phy, adding
> >>precautions linked to ERRATA Item 4:
> >>
> >>Item 4: MDIO Interface and Repeated Polling
> >>Problem: Repeated polling of odd-numbered registers via the MDIO interface
> >>	randomly returns the contents of the previous even register.
> >>Implication: Managed applications may not obtain the correct register contents
> >>	when a particular register is monitored for device status.
> >>Workaround: None.
> >>Status: This erratum has been previously fixed (in rev A3)
> >Hmm. Were did you get the hardware from? We have been using LXT973 in
> >our products and the A2 was replaced by A3 in 2003.
> >
> >Best regards,
> >	Lutz
> They are custom boards that my company manufactures. Most boards
> manufactured before 2006 or 2007 have this buggy chip.

Ok, so this problem indeed is related to (very) old hardware.
I would not be sure whether the hack needed to work around
this bug should be added one decade after the chip has
been fixed.

Best regards,
	Lutz
PS.Yes, we have used the same workaround with such hardware, fortunately
we only had a few first boards using A2 and the series production
started just with A3 at that time.
-- 
Dr.-Ing. Lutz Jänicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.921028-200
fax: +49.30.921028-020
Rudower Chaussee 13
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Christoph Leifer
