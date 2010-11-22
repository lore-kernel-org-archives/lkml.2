Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0KVHtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:49:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37849 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0KVHtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:49:14 -0500
Date: Mon, 22 Nov 2010 08:48:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com
Subject: Re: [RFC] persistent store
Message-ID: <20101122074854.GA24425@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
	akpm@linux-foundation.org, ying.huang@intel.com
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
 <20101121090707.GA5016@liondog.tnic>
 <AANLkTincT5w82v0964Pfaw+yudmDC2D1uGkC9p6_N23_@mail.gmail.com>
 <20101122073227.GA17928@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101122073227.GA17928@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 08:32:27AM +0100, Borislav Petkov wrote:
> Do you see my point? (I could very well be completely offcourse too :))

Yes I was :)

ps->data still points to the corresponding kernel buffer. And you keep
it around until the driver is removed/machine shutdown.

-- 
Regards/Gruss,
    Boris.
