Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0FPIjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:39:11 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55428 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0FPIjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:39:09 -0400
Date: Wed, 16 Jun 2010 10:39:03 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100616083903.GU17833@buzzloop.caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524161527.GC3182@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, May 24, 2010 at 09:15:28AM -0700, Dmitry Torokhov wrote:
> On Mon, May 24, 2010 at 06:08:05PM +0200, Daniel Mack wrote:
> > any feelings about this approach?
> > 
> 
> Still pondering...I applied the very first patch though...

Any news about this? I have no problem throwing away the whole patch set
and use a different approach, if there is any :)

And I need one, because I have a patch pending for a MIDI/Controller
device which is something like a drum computer control device, and this
one has more ABS information channels than currently supported by the
input stack.

OTOH, the current plan is to use *axis* information for the transport
to the user space, but in fact, their hardware representation is a
pressure-sesitive button. Same counts for potentiometers etc, which
aren't axis either. So maybe I should use some different layer for such
devices? MIDI legacy after all? I'm open to any suggestions :)

Thanks,
Daniel

