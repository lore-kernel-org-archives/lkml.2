Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2J1M03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 08:26:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50697 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551Ab2J1M01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 08:26:27 -0400
Message-ID: <1351426335.2008.6.camel@joe-AO722>
Subject: Re: [PATCH 00/16] treewide: Convert dev_printk(KERN_<LEVEL> to
 dev_<level>(
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pcmcia@lists.infradead.org, linux-scsi@vger.kernel.org,
        devel@open-fcoe.org, virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org
In-Reply-To: <508D0ECA.8040008@mvista.com>
References: <cover.1351411047.git.joe@perches.com>
	 <508D0ECA.8040008@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 28 Oct 2012 05:12:15 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 14:54 +0400, Sergei Shtylyov wrote:
> Hello.

Hi Sergei.

> On 28-10-2012 12:05, Joe Perches wrote:
> 
> > dev_<level> create smaller objects than dev_printk(KERN_<LEVEL>.
> > Convert non-debug calls to this form.
> 
> > Joe Perches (16):
> >    tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
> [...]
> >    tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
> [...]
> >    tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
> 
>     Hm, somehow this patch is repeated thrice?

Nope, I forgot to edit the 0000 file after I edited
patches locally when I noticed I forgot to update
the subject lines.  Patches are corrected, 0000 not.

I don't think it's a bit deal, I could repost just the 0000
if you want though.

cheers, Joe



