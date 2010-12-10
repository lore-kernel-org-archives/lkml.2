Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0LJWX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:23:29 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:47072 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0LJWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:23:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V+uegn1PRurGTiMhCcoQFSskuvMSFF3g/kHFHROpXfMrA0NbPNmb1J68giGJmPd3/q
         6QsvCQ4uYJ7P0xJuGxJ40cop5muk6dGStjQwgeKSd/Z5noBU27q4kUhx3C1N58y3Z9m8
         WRSJZnVgqvlk/hwRimfDbcgka0UzhjsTndJQ8=
Subject: Re: MEMSTICK: Add my 2 drivers
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <s5hk4jj1ko4.wl%tiwai@suse.de>
References: <1291862363.7792.28.camel@maxim-laptop>
	 <619119.14301.qm@web37606.mail.mud.yahoo.com>
	 <s5hk4jj1ko4.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Dec 2010 00:23:21 +0200
Message-ID: <1292019801.31669.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 08:15 +0100, Takashi Iwai wrote:
> At Wed, 8 Dec 2010 18:44:04 -0800 (PST),
> Alex Dubov wrote:
> > 
> > > 
> > > Since I don't touch (and don't want anymore to) any code
> > > written by
> > > Alex, and I even added workarounds for bugs in his jmicron
> > > driver to the
> > > generic ms_block.c code (it tested and works on my both
> > > card readers),
> > > maybe even add these to 2.6.37?
> > 
> > This are worked around by the recent patches, are not they?
> 
> Do you mean that the support for old memstick media was added / worked
> around in the recent patches?  That would be great.  It's what I was
> looking for right now.  If so, could you point your patches?
No, Alex is talking about your patches.

Best regards,
	Maxim Levitsky

