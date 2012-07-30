Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab2G3RQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:16:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47797 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2G3RQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:16:21 -0400
Date: Mon, 30 Jul 2012 19:16:29 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120730171629.GA3271@joi.lan>
References: <500D916A.60703@odi.ch>
 <20120724170002.GA3129@joi.lan>
 <500ED9EC.5040309@odi.ch>
 <20120724205746.GA8707@joi.lan>
 <500FB279.1020904@odi.ch>
 <20120725184205.GA3119@joi.lan>
 <50113E76.9090706@odi.ch>
 <20120729201532.GA3566@joi.lan>
 <50166D15.7090305@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50166D15.7090305@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 01:16:37PM +0200, Ortwin Glück wrote:
> On 29.07.2012 22:15, Marcin Slusarz wrote:
> > No, the real problem is: with "noaccel" we don't register "software engine",
> > but vblank ISR relies on its existance and happily derefences NULL pointer.
> >
> > Now, this patch should fix it for real...
> 
> Unfortunately I am still seeing the crash. Without "noaccel" it works though 
> (until X crashes the machine, but that is a different thing).

Are you sure you boot the correct kernel? I'm asking because your panic says its
version is "3.5.0 #3" - exactly the same as in previous crash log.

Marcin
