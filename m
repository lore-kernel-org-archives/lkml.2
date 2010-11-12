Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0KLK0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:26:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41426 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0KLK0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:message-id:content-type
         :content-transfer-encoding;
        b=If5jh+kIB54iyxQjyZ0NG4syXUNK8wCkTyFpqMQUxYaj51H0XXKM++R6qk2p44F4iq
         GoEPNyzcwftkcev9rE0a4FTJ1yNc/d1mxEbj0euaYZxDTt084gld4S6lyEQVT/snHwOs
         Gr2Xc2swpoqUymKUVr/5nCuIfIQXrOrFqdsRk=
From: Florian Fainelli <florian@openwrt.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Fri, 12 Nov 2010 11:26:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-server; KDE/4.5.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <alpine.LFD.2.00.1011110139200.2900@localhost6.localdomain6> <adawrojkz9v.fsf@cisco.com>
In-Reply-To: <adawrojkz9v.fsf@cisco.com>
Organization: OpenWrt
MIME-Version: 1.0
Message-Id: <201011121126.08630.florian@openwrt.org>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 November 2010 04:15:56 Roland Dreier wrote:
>  > >  > Isn't the openwrt stuff just drivers and some arch specific code?
>  > >  > Nothing that is core infrastructure, and nothing preventing them
>  > >  > from submitting the drivers and arch code if they want to, right?
>  > > 
>  > > Actually openwrt has some core infrastructure for managing (ethernet)
>  > > switches as extra-fancy multiport PHYs.  That means that all the
>  > > drivers in openwrt for the typical 5-8 port switches in home routers
>  > > don't really apply to mainline.
>  > 
>  > Why not? Those switches _ARE_ extra-fancy multiport PHYs. And AFAICT
>  > we have no support for this stuff in mainline at all.
>  > 
>  > So where is the problem ?
> 
> There's no real problem.  I was just pointing out that the openwrt
> switch stuff actually does have some core infrastructure that mainline
> is missing.  ie openwrt is not just drivers and arch code.
> 
> But yes I agree mainline should really do a better job of supporting
> ethernet switches, and clearly openwrt has the most real-world
> experience with implementing that.

We are in the process of cleaning up that code and hope to submit for review 
within the next few weeks.
--
Florian
