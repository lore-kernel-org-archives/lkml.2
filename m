Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0ENQmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:42:15 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:52648 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0ENQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DVsAHGezp6UfsR1C6aT+Z1qF5Th0+BTQd4EPx0yVLdkq8NItk0UJXz5w6jNv/TcxsM
         5wUzcyhpNdQFoqNnQeCB1e1aXxRnP9WxKwQfFuvQH9e1DnflAPDYtaPPJoV0/xQbS+kR
         U5pzA4h7qMU+Qq88hCLAqGgEckiqSWmn0Ban4=
Date: Fri, 14 May 2010 09:42:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 3/3] input: Default to only using PNP for i8042 probing
 on x86
Message-ID: <20100514164200.GD31607@core.coreip.homeip.net>
References: <1273853403-2870-1-git-send-email-mjg@redhat.com>
 <1273853403-2870-3-git-send-email-mjg@redhat.com>
 <20100514163158.GC31607@core.coreip.homeip.net>
 <20100514163643.GB7843@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514163643.GB7843@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 05:36:43PM +0100, Matthew Garrett wrote:
> On Fri, May 14, 2010 at 09:31:59AM -0700, Dmitry Torokhov wrote:
> > On Fri, May 14, 2010 at 12:10:03PM -0400, Matthew Garrett wrote:
> > > Experimenting with Windows has revealed that it will not probe the
> > > keyboard controller unless a valid PNPACPI device is present. Change our
> > > behaviour to match, and add a new i8042.forcedprobe parameter to allow
> > > people to override it.
> > > 
> > 
> > i8042.nopnp would not do?
> 
> It could - it wouldn't be quite semantically equivalent, but I don't see 
> why it wouldn't work.
> 

I think they are exactly equivalent - "piss on what PNP says, bang the ports
directly".

-- 
Dmitry
