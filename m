Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257Ab2DMLBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:01:20 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:56153 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2DMLBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:01:19 -0400
X-IronPort-AV: E=Sophos;i="4.75,417,1330905600"; 
   d="scan'208";a="11923192"
Date: Fri, 13 Apr 2012 12:05:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
CC: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gerd Hoffmann <kraxel@suse.de>, Alan Cox <alan@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: tty, hvc, xen: leak? dead code? everything is fine?
In-Reply-To: <20120412220048.GM4245@type.famille.thibault.fr>
Message-ID: <alpine.DEB.2.00.1204131200330.15151@kaball-desktop>
References: <alpine.LNX.2.00.1204122318480.7553@swampdragon.chaosbits.net> <20120412220048.GM4245@type.famille.thibault.fr>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1190695860-1334314854=:15151"
Content-ID: <alpine.DEB.2.00.1204131201340.15151@kaball-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1190695860-1334314854=:15151
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1204131201341.15151@kaball-desktop>

On Thu, 12 Apr 2012, Samuel Thibault wrote:
> Jesper Juhl, le Thu 12 Apr 2012 23:33:20 +0200, a écrit :
> > Or *if* there's actually no way 'info->intfw' can actually be anything but 
> > NULL in this case,
> 
> There is no way that it's both non-NULL and the if was entered above: if
> the if was entered, the content of info is zeroes (kzalloc).
 
Yep. Thanks Samuel for the quick answer.
 
In more details: if the console has already been configured info->intf
is not NULL.
On the other hand if the console hasn't been configured yet info->intf
is NULL.

If the console has just been allocated by the kzalloc then obviously
it hasn't been configured and in fact info->intf is NULL.
--8323329-1190695860-1334314854=:15151--
