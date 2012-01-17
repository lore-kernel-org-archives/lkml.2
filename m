Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2AQQBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:01:17 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45954 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2AQQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:01:13 -0500
Date: Tue, 17 Jan 2012 10:45:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-16
Message-ID: <20120117154521.GF12733@tuxdriver.com>
References: <20120116195435.GB12733@tuxdriver.com>
 <20120116.201507.597966888285215358.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116.201507.597966888285215358.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 08:15:07PM -0500, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 16 Jan 2012 14:54:35 -0500
> 
> > Here is a set of fixes for 3.3 that I let cook over the weekend...
> > 
> > Included is a fix for a signedness bug in ipw2x00 from Dan Carpenter, a
> > fix for an oops when ejecting a b43 card from Guennadi Liakhovetski
> > (with a minor modification by me as noted in the changelog), a mac80211
> > regresion fix from Johannes Berg for a bug related to station
> > management, and a final fix for the rt2800pci spurious interrupt issue
> > from Stanislaw Gruszka.
> 
> And Linus's patches to fix the brcmsmac driver aren't in here because?
> 
> If you don't integrate them, Linus is going to integrate them on his
> own before -rc1 is cut, so whatever you're "waiting for" is entirely
> and utterly pointless.
> 
> Merge his bug fixes now, don't delay this kind of stuff, ever.

OK, I withdraw this pull request.  I'll send a replacement immediately.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
