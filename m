Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0DVIjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:39:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61016 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0DVIjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FcYwcKvSn/sSPMUiwCC0/vlQhSa/Vp870qwlYHCenVTw0bg2KPQAX7IE+RnIjQzuzw
         1mzNlBUQulq0100YRtbNiqtrkTABGRjyHIpt/T6HUu3/uLHDYcre31WQ2g6WFlE77hj2
         VKv3AgABfX0YbAbwKUsBPXIfm2e+eFh+dsCOc=
MIME-Version: 1.0
In-Reply-To: <20100309115743.48cc125b.akpm@linux-foundation.org>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
	 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
	 <5ec8ebd51003081703r76fd2ba7pa850f7568a580181@mail.gmail.com>
	 <20100309115743.48cc125b.akpm@linux-foundation.org>
Date: Thu, 22 Apr 2010 11:39:51 +0300
Message-ID: <r2q5ec8ebd51004220139m2df20715y259c9fdd65373b11@mail.gmail.com>
Subject: Re: [PATCH 01/11] lib: introduce common method to convert hex digits
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 10:57 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> This patch series turned up two days before the 2.6.33 release, which
> is fairly exactly the time when non-bugfixes won't get looked at!  I
> stored it all away for consideration after we've finished the
> 2.6.34-rc1 merge scramble.
Any news here? Should I resubmit series?

-- 
With Best Regards,
Andy Shevchenko
