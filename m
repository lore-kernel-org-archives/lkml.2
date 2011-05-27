Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1E0MqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:46:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56925 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1E0Mp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fDRcVFw0ymOqiRA6Y9BQkbCn08yvvw+lifqlqcsnkOMAkGVxJy4iT5bXpWy0Y7HBrH
         mG4B02I0DaTOhtlvmO6DYC7rYrkv/KKtCE114o/nwFHsZ7QRlRUn7ZTfj1HAp1RgEC7R
         KQgxGn4CT72jsoUTB7RtfbmZwhUnNwkW3jgCU=
Date: Fri, 27 May 2011 16:45:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] battery-2.6.git
Message-ID: <20110527124554.GA10149@oksana.dev.rtsoft.ru>
References: <20110527105407.GA29529@oksana.dev.rtsoft.ru>
 <alpine.LFD.2.02.1105271200490.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105271200490.3164@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 12:10:37PM +0100, David Woodhouse wrote:
> On Fri, 27 May 2011, Anton Vorontsov wrote:
> > 
> > are available in the git repository at:
> >   git://git.infradead.org/battery-2.6.git master
> 
> Please note that git.infraded.org moved to a new IP address yesterday. And 
> I stupidly forgot to update one of the nameservers, so the DNS is still 
> propagating and for the next few hours you might still get the old 
> address.
> 
> IPv6 will be fine as it hasn't changed, but if you're stuck with Legacy IP 
> and it doesn't work, make sure you have the new IP address 173.166.109.252

Thanks for the heads up!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
