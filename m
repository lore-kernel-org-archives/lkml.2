Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1JOWcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:32:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44007 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1JOWcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:32:12 -0400
Date: Sun, 16 Oct 2011 00:32:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] acerhdf: Add support for new hardware
Message-ID: <20111015223210.GC16432@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Feuerer <peter@piie.net>, mjg@redhat.com,
	linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20111014234055.2265c524.peter@piie.net>
 <20111014234334.a87a2388.peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111014234334.a87a2388.peter@piie.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Oct 14, 2011 at 11:43:34PM +0200, Peter Feuerer wrote:
> From: Peter Feuerer <peter@piie.net>
> 
> Add support for new hardware:
> Acer Aspire LT-10Q/531/751/1810/1825,
> Acer Travelmate 7730,
> Packard Bell ENBFT/DOTVR46
> 
> To prevent from hardware defects, the default temperature values have been
> decreased.

do you have some actual bug reports stating that the original
temperature values were causing hw defects?

Thanks.

-- 
Regards/Gruss,
    Boris.
