Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2HURIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:08:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HURIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:08:17 -0400
Date: Tue, 21 Aug 2012 19:08:13 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/46] 3.5.3-stable review
Message-ID: <20120821170813.GA1561@fancy-poultry.org>
References: <20120820035832.274275502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:4cQ94hy5J6YXWWVx5M4xlc3LYsSfLLjpk+NrAPdwnvT
 M7enCzppyj2Z+MmztejPg6UjbKdwyA/TPCx8wALFXQsbIYtd3I
 i6SuVha4KrJcvF0k41PdrsocutCcZfG3illmtcSxI8TWBLHLM7
 R27IKxsbDsE6OxNm/sc/dHpb7P82ulAgV2o/Z31oiAdq440CtL
 QW/3nP7X5hlMO5l5NnnG9F1HoZV3+tdwdOWb3cb444EPSy5TML
 bc9JRIQ7tsJ4mLol75itu/lDtnFgVPXImZYB4NyOEraGDHWjma
 C+GDC/zvzTbVgP1Gm5tH59zpaA40J4QokU1YCw2zM+QrNFXWSW
 yvPxp8z/ggVALp6+6RNIsjV2k0vyloKR4GHjhK1R2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.2012, Greg Kroah-Hartman wrote: 

> This is the start of the stable review cycle for the 3.5.3 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

3.5.3-rc1 hangs my machine on boot (can reboot with CTRL-ALT-DEL). 
All other kernels are/has been fine, incl. latest 3.5.2 and 3.6-rc1. 

There's nothing in the logs, but you can see a screenshot here:
http://www.fritha.org/hang.jpg

Here it stops, and I have to reboot.

