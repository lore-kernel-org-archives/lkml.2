Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0LBQVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:21:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58746 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab0LBQVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TS7evgrQuoRW5Yzead13gXpOzsiirjAnAcU1wLND6HGTrx5epoA+cLsdBgd47O1xsT
         7Wpitp9ZcdJP+WIN+4xNnZ0269xuXcWg29F8k20hiUmZqJ9ju6G0nY1BKzmpMuceASgX
         tpJBJDE6fOF0EogqvatdhPY+hAgL+yI+rJoE8=
Subject: Re: edac_core: crashes on shutdown
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101202152106.GA29301@a1.tnic>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	 <20101201123921.GA15530@a1.tnic> <1291209888.12511.11.camel@Tobias-Karnat>
	 <20101201143329.GB18074@a1.tnic> <1291225614.8646.4.camel@Tobias-Karnat>
	 <20101201193508.GA4916@liondog.tnic>
	 <1291280613.10626.22.camel@Tobias-Karnat>  <20101202152106.GA29301@a1.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 17:21:12 +0100
Message-ID: <1291306872.3898.7.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 02.12.2010, 16:21 +0100 schrieb Borislav Petkov:
> Well, thanks for the photos. I don't have an idea what might cause this
> workqueue corruption I'm seeing, all reg/unreg paths look ok. The only
> change that came in between .35 and .36.1 I can think of being relevant
> is 00740c58541b6087d78418cebca1fcb86dc6077d. You could try backing that
> one out to see whether it fixes the issue.

Yes, reverting this fixed the issue!

But why?

-Tobias


