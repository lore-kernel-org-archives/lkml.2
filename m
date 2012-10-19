Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab2JSQBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:01:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab2JSQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:01:17 -0400
Date: Fri, 19 Oct 2012 18:01:03 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [ 60/76] drm/nouveau/bios: fix shadowing of ACPI ROMs larger
 than 64KiB
Message-ID: <20121019160103.GA1570@fritha.org>
References: <20121019024350.087156547@linuxfoundation.org>
 <20121019024359.774396402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019024359.774396402@linuxfoundation.org>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:YlBfVv4+MQ7zKtTxVZ0vGExFFs7iMJBHjgcY+h0Q8ID
 cXsq9APZRJu02XzX9/hMHhrcEFDY6hMNjyOOJD/hxiwNSDCApI
 Yj4J4co+Z7VJXp0BnoycSX0UnORly7pCcrQuIpKcT5Tmb50aFF
 SOoycFur2g1dNjGbe5jgr+YJaXKKiQYRuAcdrN7/1G5OqdRRpT
 r0jKncNAW+WoESvMf2OoQ5zi+WJ9t3SYv06XV5HjqXLAOEOxej
 s4d/1ryfWO8s7CK7u2QoEoDAylh//D2VsASS5cBml4MRyXkAmY
 0Fu+KOqj28lgnpG8lU7Ps8gB8ttlxbUWT83VqxdS1r5/HOULsy
 DEgQsvSSPyWMvVVNZIx4jBUue/GpMh88gEIogr5YN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.10.2012, Greg Kroah-Hartman wrote: 

> 3.6-stable review patch.  If anyone has any objections, please let me know.

While 3.6.2 is fine. 3.6.3-rc1 crashes my machine (Asus U45-JC) at
boot. A screenshot of the output is here:

http://www.fritha.org/crash.jpg

Reverting this one fixes it:

> Ben Skeggs <bskeggs@redhat.com>
>     drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB


