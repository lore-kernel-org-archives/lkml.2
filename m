Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0GDF0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 01:26:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53212 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab0GDF0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 01:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=flwUWJRXNouI4JOsKjJSHl0642QaIXG+a5NcuT3B/hQ0kM07OQLCVCfF6BvK7JTyzh
         XteBTfJmEKUJLqfXV1ngudovdpx0HcPieTehoJq8Im+MWjr+V9bOO2NWpg3jULpaNyAE
         /6SN0C2w8S5MO8YF1XNfHE7ODQy04Kzg5IpGw=
Date: Sat, 3 Jul 2010 22:26:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jerome Lacoste <jerome.lacoste@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100704052631.GA32427@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
 <20100701162454.GD4152@core.coreip.homeip.net>
 <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
 <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
 <20100701224235.GA29504@core.coreip.homeip.net>
 <AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
 <20100703212015.GA32052@core.coreip.homeip.net>
 <20100704045315.GA7836@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100704045315.GA7836@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

On Sun, Jul 04, 2010 at 01:53:15AM -0300, Henrique de Moraes Holschuh wrote:
> Won't this cause an extra delay on resume to everyone who has a device
> with proper firmware?

I do not think that i8042 reset itself takes long time, touchpads are
the ones that need about 1 sec to do a full reset, 

> 
> Would it be possible to reset the i8042 only if failures to bring the
> active multiplexer are detected?
> 

Failure to revive multiplexor is the only issue there is...

-- 
Dmitry
