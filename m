Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1DNQiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:38:25 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:45436 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752818Ab1DNQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:38:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PDMedMSc9J762zSXmkK/v7fLxVO9kV22QZur6tje+SC7XajO9LkfoKlEfZMj2wiDP8lw7PUdQNlgvaGUsxs8NJ3uZw5LaJDX+mn40SUZ3m1Pljn1RNkrrK9xhivvlm88;
Date: Thu, 14 Apr 2011 09:38:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Xianghua Xiao <xiaoxianghua@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: Disable PCI while CONFIG_PCI=y
Message-ID: <20110414093804.0f945ed2@jbarnes-vaio.home>
In-Reply-To: <20110413153724.5776f7e5.rdunlap@xenotime.net>
References: <BANLkTikAqz5xBRfpxBuwxVujE--Qam2FsQ@mail.gmail.com>
	<20110413131054.8771d855.rdunlap@xenotime.net>
	<BANLkTi=KvxPNuvZnL90SAmkQna=ARE6xyQ@mail.gmail.com>
	<20110413153724.5776f7e5.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 15:37:24 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Wed, 13 Apr 2011 17:01:38 -0500 Xianghua Xiao wrote:
> 
> > Yes I read that but my ARCH is arm.
> > 
> 
> It would probably make sense to implement
> 	pci=off
> for any $arch.
> 
> Any problem with that, linux-pci??
> 

Yeah I'm ok with it assuming the patch looks good and isn't too
invasive.  I'd think on EP devices you'd want a more pared down kernel
image (so CONFIG_PCI=n among many other things), but if you really want
to share binary images yeah we'll need a runtime check.

Jesse
