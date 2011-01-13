Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1AMP4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:56:07 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:52262 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757208Ab1AMP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:56:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bD7kavq0XA59Y0Adtl7Q1Yw5S4lofrbvncpp+JM6LM6DWK2Prkv110akSTi0RTF2umVGsSlwrWsEia/eZ2FSoHn6dSaJ899gGaLdQfydzRdj0tnbzLXPuXmpp3Ek0rpn;
Date: Thu, 13 Jan 2011 07:55:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Len Brown <lenb@kernel.org>
Cc: Narendra_K@Dell.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, Matt_Domsch@Dell.com,
        Charles_Rose@Dell.com, Surya_Prabhakar@Dell.com
Subject: Re: CONFIG_NLS=m resulting in undefined reference to
 utf16s_to_utf8s causing build failure
Message-ID: <20110113075556.789ac3c3@jbarnes-vaio.home>
In-Reply-To: <alpine.LFD.2.02.1101122217370.19754@x980>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
	<20110112160229.7b8d82c1@jbarnes-desktop>
	<alpine.LFD.2.02.1101122217370.19754@x980>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.208.206.255 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 22:23:55 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:
> > So there's no other ACPI code that depends on this function?  I'd hate
> > to make PCI depend on NLS, so assuming ACPI doesn't need it (in which
> > case the select or depend should be there), I guess it should be pulled
> > into a common file that will always be included.
> 
> No, nothing in the ACPI code uses utf16s_to_utf8s.
> 
> I don't know anything about NLS, but it appears to be
> something that file systems (befs, cifs, fat, hfs, isofs, jfs, etc)
> use to to support native languages.
> 
> BTW. I don't understand why pci-label.o appears twice above.
> It used to be just the 2nd one, that depends on CONFIG_DMI.

Ok, I'll drop this patch for now then since I haven't seen a fix yet
and need to get Linus the rest of the changes.

Thanks,
Jesse
