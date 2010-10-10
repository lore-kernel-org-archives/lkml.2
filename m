Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab0JJVEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 17:04:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49540 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0JJVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 17:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8u86Evoe2i8KA/hEfvFc/YwhhPADqNKdtj8L8/FiGGldgpVjzdF9wFAzlBs6+Q2/W
         qd1mgSL+hrCPdrMQqNtrM3Tijadgy5TQmyqx1wG3n/VUHEWtfRNU7fdIRbvUmfCvRBUd
         +FNjzoESx3QKV7chJCRcNn52zp572payM5aJk=
Date: Sun, 10 Oct 2010 14:04:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-input@vger.kernel.org,
        xorg-devel@lists.x.org, Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
Message-ID: <20101010210434.GC18455@core.coreip.homeip.net>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
 <s5hfwwg4p4t.wl%tiwai@suse.de>
 <1286558135.22715.162.camel@mini>
 <201010081104.01527.dmitry.torokhov@gmail.com>
 <s5h62xc4h2l.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h62xc4h2l.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 09:31:30PM +0200, Takashi Iwai wrote:
> At Fri, 8 Oct 2010 11:04:01 -0700,
> Dmitry Torokhov wrote:
> > 
> > So I do believe we need to have Takashi's SOB at the very least and maybe
> > credit him as the author of the patches.
> 
> I sent my original one, so this should suffice, right?
> 

Takashi,

Generally I think people should not add or remove any SOB lines except
for their own as the work on the patches, so original patches should
retain their original SOBs... In absence of that I'd like to have
explicit confirmations that I can add SOBs statements; otherwise it just
dilutes the value of SOBs significantly.

Thanks.

-- 
Dmitry
