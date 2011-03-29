Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1C2QXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:23:55 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56810 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751394Ab1C2QXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:23:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S+h2XelL5cLi2L8K9jwshZILKV9ZG9WVqd3867JkJMnEtK48uemyEi7CEeiH5unPSafvg/Z7cEebMuNh+kx+nAaba3NL269Nd2oGQKMeELo5FMkvcpscYE5L9+CGmxNO;
Date: Tue, 29 Mar 2011 09:23:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Shyam_Iyer@Dell.com,
        mjg59@srcf.ucam.org, Narendra_K@Dell.com, viro@zeniv.linux.org.uk,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Matt_Domsch@Dell.com,
        Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-ID: <20110329092303.43430e15@jbarnes-desktop>
In-Reply-To: <4D92063C.8040202@oracle.com>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
	<20110328080220.1390d28e.randy.dunlap@oracle.com>
	<DBFB1B45AF80394ABD1C807E9F28D15702659CFB3D@BLRX7MCDC203.AMER.DELL.COM>
	<4D90EDE8.9070306@oracle.com>
	<87oc4u4rn4.fsf@devron.myhome.or.jp>
	<4D92063C.8040202@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 09:18:04 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On 03/28/11 18:55, OGAWA Hirofumi wrote:
> > Randy Dunlap <randy.dunlap@oracle.com> writes:
> > 
> >>> I don't get this.. you should not be getting CONFIG_NLS=m unless you
> >>> have stripped you config files really.. :-) Is it possible to get
> >>> your .config to hit this issue.
> >>
> >> I haven't stripped any config files -- but they are randconfig files.
> >> Two (2) config files that cause build failures are attached.
> > 
> > config PCI_IOAPIC
> > 	bool
> > 	depends on PCI
> > 	depends on ACPI
> > 	depends on HOTPLUG
> > 	default y
> > 
> > select NLS if (DMI || ACPI)
> 
> Ugh.  That looks seriously mucked up.
> Dell people, have you checked what it is linux-next for this pci-label stuff?
> 
> Jesse, I would drop the b0rked pieces and ask for a new patch.

Should be the same as what's in Linus master at this point...  But yes
I'm tempted to revert since it's been nothing but trouble so far.

Narendra, any chance you can get me a fix today?  If not I'll queue up
a revert and you can try again in the next cycle.

-- 
Jesse Barnes, Intel Open Source Technology Center
