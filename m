Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1FNRQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:16:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54141 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1FNRQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vbb/z5E+7trxw1Kr4toTZ+eow2u84mn0lPi1FQLOKonjgLPZ3iy4aMgA4A12ArfSw3
         rTdg0jtmjd0KqFiexmCZ1QYOZlO4t7Rrgr+Dx3+fBk+rA+M37GUfr3JgOT7LtsDfbQbe
         e1n6qzNde2yflBneAfRaEH7wFPiBMYW7eP13Y=
Date: Tue, 14 Jun 2011 20:16:19 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module option
 description
Message-ID: <20110614171619.GB23739@shale.localdomain>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
 <20110613122717.GF3583@shale.localdomain>
 <20110614164649.GB29015@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614164649.GB29015@tugrik.mns.mnsspb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 08:46:49PM +0400, Kirill Smelkov wrote:
> On Mon, Jun 13, 2011 at 03:27:17PM +0300, Dan Carpenter wrote:
> > On Mon, Jun 13, 2011 at 04:18:29PM +0400, Kirill Smelkov wrote:
> > > Both bars=0 and bars=1 were described as meaning to display bars on
> > > signal lost. Actually bars=1 means "display bars", but bars=0 means
> > > display raw source as is (usually black screen).
> > 
> > Your description up here is much better than the one in the README.
> > Maybe just include yours and delete the original.
> 
> Thanks for head ups. Something like this:
>

I like it.  :)

regards,
dan carpenter

