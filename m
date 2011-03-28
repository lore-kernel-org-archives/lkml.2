Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1C1QRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:17:43 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:50904 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751754Ab1C1QRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:17:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PFJyhvgD05hrjxS5rGc/3t2DCB2SQ7Zf70ozFMV5t7JjzjgIlM7oWoSr6NmMs5zbg3wtq/9E967s4uq3rIbpwve6+/Bf7WPxK3kgalk+tpxOAO1yr6X+6QNGcvW1Jnj1;
Date: Mon, 28 Mar 2011 09:17:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Narendra_K@Dell.com,
        viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Shyam_Iyer@Dell.com, Matt_Domsch@Dell.com, Charles_Rose@Dell.com,
        Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-ID: <20110328091732.12e7d850@jbarnes-desktop>
In-Reply-To: <20110328080220.1390d28e.randy.dunlap@oracle.com>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
	<20110328080220.1390d28e.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 08:02:20 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> This driver still has build failures in linux-next 20110328.
> 
> pci-label.c:(.text+0x9a40): undefined reference to `utf16s_to_utf8s'
> 
> CONFIG_NLS=m

Narenda, please send a fix asap.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
