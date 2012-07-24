Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2GXU5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:57:38 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45198 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2GXU5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:57:37 -0400
Date: Tue, 24 Jul 2012 22:57:46 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120724205746.GA8707@joi.lan>
References: <500D916A.60703@odi.ch>
 <20120724170002.GA3129@joi.lan>
 <500ED9EC.5040309@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500ED9EC.5040309@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 07:22:52PM +0200, Ortwin Glück wrote:
> On 24.07.2012 19:00, Marcin Slusarz wrote:
> > Please post the crash log.
> 
> Sorry, I was not precise: it boots until drm performs modesetting (so it 
> seems). The screen goes black and the machine is dead. So there is 
> nothing I could post here, unfortunately.
> 
> This is a video of 3.5 booting:
> http://www.odi.ch/VIDEO0010.3gp

Does it work if you boot without X and modprobe nouveau manually? If it does,
can you disable page flipping in xorg.conf (Option "PageFlip" "0" in nouveau
device section) and recheck with X?

Does it work if you disable acceleration (nouveau.noaccel=1 in kernel command
line)? Is there anything saved in /var/log/ from previous boot? Can you ssh
into and check dmesg? Can you use netconsole and catch full log?

Marcin
