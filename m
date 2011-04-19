Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1DSQZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:25:18 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:57261 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752353Ab1DSQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:25:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uXnoPMDEVmPOKTGeGiBK8LiZhHFdDnIbLlnw8/sBoptC9K1nEpylS8bYbEbRSwhI1GveLXPaolBm+7oxt/0FOqcVT21V3etN9EzL5WCblIlIPy7xL66DZP5cljR/iuK5;
Date: Tue, 19 Apr 2011 09:25:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: <Narendra_K@Dell.com>
Cc: <mingo@elte.hu>, <viro@zeniv.linux.org.uk>, <mjg@redhat.com>,
        <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <Shyam_Iyer@Dell.com>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Jordan_Hargrave@Dell.com>
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-ID: <20110419092513.28cc68e1@jbarnes-desktop>
In-Reply-To: <E31FB011129F30488D5861F3839049151DA2EC035A@BLRX7MCDC201.AMER.DELL.COM>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110419060641.GA26624@elte.hu>
	<E31FB011129F30488D5861F3839049151DA2EC035A@BLRX7MCDC201.AMER.DELL.COM>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 01:43:53 -0700
<Narendra_K@Dell.com> wrote:

> > -----Original Message-----
> > From: Ingo Molnar [mailto:mingo@elte.hu]
> > Sent: Tuesday, April 19, 2011 11:37 AM
> > To: K, Narendra
> > Cc: viro@zeniv.linux.org.uk; jbarnes@virtuousgeek.org; mjg@redhat.com;
> > sfr@canb.auug.org.au; linux-kernel@vger.kernel.org; linux-
> > next@vger.kernel.org; Iyer, Shyam; Domsch, Matt; Rose, Charles; Hargrave,
> > Jordan
> > Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
> > allmodconfig
> > 
> > 
> > * Narendra_K@Dell.com <Narendra_K@Dell.com> wrote:
> > 
> > > This patch fixes the following build breakage introduced by the patch
> > > '[PATCH V3] Export ACPI _DSM provided firmware instance number and
> > > string to sysfs'.
> > >
> > > drivers/built-in.o: In function `T.647':
> > > pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'
> > 
> > btw., this build bug still triggers upstream with .39-rc4 - any plans on when
> > this regression will be fixed?
> 
> Hi,
> 
> The commit  8a226e00eeed8db843d4a580013a49ae3559bcd7 in linux-next fixes it (PCI: pci-label: Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig).
> It is not in .39-rc4.

Yeah, I'll push it today (it's in my for-linus branch too).  Thanks for
the reminder.

-- 
Jesse Barnes, Intel Open Source Technology Center
