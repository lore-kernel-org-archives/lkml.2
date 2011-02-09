Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1BILIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:08:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1BILIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:08:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kKoIrf38Vm17o/fA9F2fpMLsZVzDPG2FUBZXcFCCKJBa7Ji2OEM891k6fbaOzDUeyZ
         P2EQslXwjj4FLvwTIF/utwP+18CTokj6QNQqb44GtwteabDi6FWhoICa7oL5muSuqn5I
         4mFlzixLHjbnFmkyR4o+DuEoY48TLyU6wBfcA=
Date: Wed, 9 Feb 2011 14:08:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in
 write_blk_fifo() function.
Message-ID: <20110209110834.GY4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Belisko Marek <marek.belisko@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
 <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
 <20110126130718.GN2721@bicker>
 <20110126143045.GP2721@bicker>
 <AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
 <20110208163531.GO4384@bicker>
 <AANLkTi=u1M1Gu1y7kmaPSTd4CDUWkgowYLpQRSpwRyEY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=u1M1Gu1y7kmaPSTd4CDUWkgowYLpQRSpwRyEY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:07:19AM +0100, Belisko Marek wrote:
> Well I test it and it seems very strange and can't figure out why.
> Will remove all byte_length manipulations and device doesn't boot properly
> (finish with error). Add some prinkt to code figure out following:
> 
> 1. byte_length = word_length *4 is < 64 we need to send via usb 68
> bytes (despite
> 4 bytes are behind 64 (without this it can't boot).
> 
> 2. also when e.g. word_length is 400 (400*4 = 1600) condition
> 1600%64 == 0 is valid and we send 1604 bytes to usb (also not sure why
> but without this change it also doesn't work).
> 

Huh.  Strange.  Thanks for testing.  Sorry for the noise.

regards,
dan carpenter


