Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0LIBZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:25:39 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43224 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0LIBZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IT5on//IT43QNq2iqcbOEveTvSYZgJaFutkr0OoRCPXolAZ/YFwCuMfahgdmgtnDFe
         ooI3vKiuGAq/UxyC49K4HzwPG9FhLwIWfuVbpvwWH+VcyOyn4HIi6GgG5Ti6nXxPbiX0
         1znPzyCnzV4LXGET1DhkZh3HxTC+CjcNdqCJk=
Subject: Re: [stable] [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when
 vid not used
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: David Miller <davem@davemloft.net>, lkml20101129@newton.leun.net,
        netdev@vger.kernel.org, jesse@nicira.com, linux-kernel@vger.kernel.org,
        greearb@candelatech.com, stable@kernel.org
In-Reply-To: <20101208231624.GA8992@kroah.com>
References: <1291108809.2904.3.camel@edumazet-laptop>
	 <20101201111716.424fb771@xenia.leun.net>
	 <1291200914.2856.546.camel@edumazet-laptop>
	 <20101208.084731.189716071.davem@davemloft.net>
	 <20101208231624.GA8992@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 02:25:33 +0100
Message-ID: <1291857933.2795.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 15:16 -0800, Greg KH a écrit :
> On Wed, Dec 08, 2010 at 08:47:31AM -0800, David Miller wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Wed, 01 Dec 2010 11:55:14 +0100
> > 
> > 
> > Greg/-stable, please integrate this patch from Eric into 2.6.36 if you
> > haven't already done so.
> 
> I've updated the version in the .36-stable queue with this one, thanks.
> 

Thanks.

By the way, all credits given to Jesse, I only made a change to his
patch, so I left him as the author.

Ah I see I forgot the "From: Jesse Gross <jesse@nicira.com>" header when
I sent it, my bad, sorry !



