Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0HNQTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:19:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51707 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab0HNQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JMt0o424t+tfPFU1pbFp8+xwzPfFRlYnSUShSnigrEpBRkD5vdIaeL48JhGFnlHlik
         wDNN3VktWWKDIrslnQZIhJcOU4KHWiLOblM6QlIHqh9d0pT2BifpnxXOlzu2jyOKFhzx
         9de+GR50ZI23TxzlVzgNgif578NbJfeUYipFw=
Date: Sat, 14 Aug 2010 20:19:15 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Sven Eckelmann <sven.eckelmann@gmx.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@web.de>
Subject: Re: batman-adv: design suggestions
Message-ID: <20100814161915.GB3258@albatros>
References: <20100809203403.GA16183@albatros>
 <201008092254.39960.sven.eckelmann@gmx.de>
 <20100812124813.GB4881@albatros>
 <201008141650.57375.lindner_marek@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008141650.57375.lindner_marek@yahoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 16:50 +0200, Marek Lindner wrote:
> On Thursday 12 August 2010 14:48:13 Vasiliy Kulikov wrote:
> > Is there any (un)official documentation/RFC/whatever of batman-adv
> > protocol? I found only expired RFC of batman that is using UDP at
> > www.open-mesh.org.
> 
> Yes, there is an unofficial one:
> http://gitorious.org/batman-adv-doc

Thank you!

> Note: This document is neither complete nor up to date. Writing proper 
> documentation for the routing protocol is on our long ToDo list. 

Do you plan to register it as RFC/IEEE/whatever when linux batman-adv
implementation is stabilized? Or you plan to improve it somehow? :)

> 
> The UDP version is very similar to the kernel module since we used the user 
> space implementation to verify the concept.
> 
> 
> Cheers,
> Marek
