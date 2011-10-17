Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1JQMNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:13:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37513 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1JQMND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:13:03 -0400
Date: Mon, 17 Oct 2011 14:13:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] acerhdf: Lowered default temp fanon/fanoff values
Message-ID: <20111017121300.GA17411@gere.osrc.amd.com>
References: <20111014234055.2265c524.peter@piie.net>
 <20111014234334.a87a2388.peter@piie.net>
 <20111015223210.GC16432@liondog.tnic>
 <cone.1318721291.690132.3813.1000@zopiie>
 <20111016084300.GB32343@liondog.tnic>
 <20111016114100.88295b72.peter@piie.net>
 <20111016114251.a710b196.peter@piie.net>
 <20111016114423.2df6271c.peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111016114423.2df6271c.peter@piie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 11:44:23AM +0200, Peter Feuerer wrote:
> From: Peter Feuerer <peter@piie.net>
> 
> Due to new supported hardware, of which the actual temperature limits of
> processor, harddisk and other components are unknown, it feels safer
> with lower fanon / fanoff settings.
> 
> It won't change much for most people, already using acerhdf, as they use
> their own fanon/fanoff variable settings when loading the module.
> 
> Furthermore seems like kernel and userspace tools have been improved
> to work more efficient and netbooks don't get so hot anymore.
> 
> Signed-off-by: Peter Feuerer <peter@piie.net>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Cc: Matthew Garrett <mjg@redhat.com>

I'm wondering whether the bios_tbl in 2/3 is not growing out of
proportions currently and since a lot of the fields are repeating, it
might make sense to fold its functionality in a switch-case statement.
Maybe in another patch series...

But those patches look ok to me:

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
Boris.
