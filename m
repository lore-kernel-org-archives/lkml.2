Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1DZPwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:52:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37576 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1DZPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vf1BygdRSZSjLZaR+5Kh3tmQleo0R0M7sFWpyHBwp34oLpsk17RzmZ8ERtqkHefJLb
         Rlqq95TYieNwmmZ+cLgh0mJ6zj6zEacj1yReFpq/SL6whm7MhoSqYnHtyaNARtuefEzm
         zg6Xx7bTrpPJETGJLfeIRD+5C/g84pZ4XVnfA=
Date: Tue, 26 Apr 2011 17:52:29 +0200
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110426155229.GM878@htj.dyndns.org>
References: <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com>
 <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 26, 2011 at 04:41:25PM +0100, Bruce Stenning wrote:
> Tejun wrote:
> > Does the following patch resolve the problem?
> 
> I have applied that patch, keeping Mark's mv_set_main_irq_mask spinlock patch
> in place.  I would not like to commit absolutely, for obvious reasons, but I
> have abused the port considerably and have not been able to coax it into
> locking up.

Yeah, it makes sense.  Hmm... it seems I wasn't thinking straight when
I added that work around.  Not sure how to fix it properly at this
moment.  I'll think about it.  Can you please keep me posted if you
find something while testing?

Thanks.

-- 
tejun
