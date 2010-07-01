Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab0GAVzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:55:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52499 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0GAVyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:message-id:content-type
         :content-transfer-encoding;
        b=mZpfBnOIlXu/1glvl/LjZZ+O+Nn5Qn2ty1LYEUQ6TVrHGhfhmu6oXrO2OSQsA7MmKH
         eIY1kZbeDonUB8xk+XDvHlLxlYIuruitcGYAbSK+xMbOgXjWKhePrTFN7WX9/v2jAe6L
         +aouGX1RClcpMYAx9D0ruzdOZkm7QRInbOO2s=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Greg KH <greg@kroah.com>
Subject: Re: 4 -stable kernel review cycles starting
Date: Thu, 1 Jul 2010 23:55:02 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20100701175100.GA2078@kroah.com>
In-Reply-To: <20100701175100.GA2078@kroah.com>
MIME-Version: 1.0
Message-Id: <201007012355.05531.florian@openwrt.org>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le Thursday 1 July 2010 19:51:00, Greg KH a écrit :
> First off, sorry for the long delay in the -stable kernel releases, they
> got pushed to the back-burner for other things recently ("Hey look, is
> that the sun finally here in the Pacific Northwest?")
> 
> Please note that there are still a large number of patches that have
> been submitted to the -stable trees for inclusion, that I have not
> included yet.  Do not worry, they are still in my queue, but due to the
> large number of patches that I already have queued up, I figured it was
> better to get what I have applied already out for a release and then
> work on catching up after this.
> 
> If anyone has any questions about this, please let me know.

Looks like this cpmac patch was not included in this -stable series: 
http://www.spinics.net/lists/netdev/msg133317.html

Can you queue it for future -stable releases or this one?

Thank you.
--
Florian
