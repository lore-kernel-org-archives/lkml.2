Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1FKMUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 08:20:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54885 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab1FKMUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 08:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T3aAndDsADtDq29jeONG3xMRiDSG+cC0R7FGxxRdYvokl9SbiZXhz77A5zq/5irR//
         +SjUUekLLhyfdDGj05MwX3jZgD6iPkZKRiiyot7JvKlNFAwtqw8+fh+yIctI1PgDbOO0
         qnEhP9j3iADc85+/Z4F+crdFZ/QuQNcooM6yg=
Date: Sat, 11 Jun 2011 14:19:57 +0200
From: Tejun Heo <htejun@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110611121957.GA7980@mtj.dyndns.org>
References: <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
 <20110525094127.GF10146@htj.dyndns.org>
 <4DF20E03.9030502@teksavvy.com>
 <20110610140155.GJ15235@htj.dyndns.org>
 <4DF25526.9010800@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF25526.9010800@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:32:22PM -0400, Mark Lord wrote:
> > I don't think it would be wise to include the patch for -stable tho.
> > It's not a regression fix and has some possibility of introducing
> > regressions, so....
> 
> Not a regression fix?  Excuse me?
> SATA hotplug always used to work fine,
> and is more or less essential to reboot-free operations.

There are two separate patches.  One is a fix which got pushed to
Linus by Jeff early yesterday.  The other changes behavior which has
been like that since the beginning of EH.  The former is marked
properly w/ -stable.  The latter shouldn't be in -stable.

Thanks.

-- 
tejun
