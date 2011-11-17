Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1KQVk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:40:58 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:53246 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1KQVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:40:56 -0500
Subject: Re: [PATCH] m68k: Remove references to obsolete CONFIG_SERIAL167
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
In-Reply-To: <1321565687.20271.309.camel@x61.thuisdomein>
References: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
	 <1321182176.20271.43.camel@x61.thuisdomein>
	 <CAMuHMdXsHgUd_oggpKoS2t6Tm8MnEjLnWmi4Hswz_nQjSWsozA@mail.gmail.com>
	 <1321559636.20271.287.camel@x61.thuisdomein>
	 <CAMuHMdW73Nf+bP2u6NRZFMW5c0-PnqYCDtEbZ+weGLs_mzZ1_g@mail.gmail.com>
	 <1321565687.20271.309.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 22:40:55 +0100
Message-ID: <1321566055.20271.313.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 22:34 +0100, Paul Bolle wrote:
> I see nothing universal about it: two independent usages, one in
> */iss/console.c and one in */amiserial.c. So I'd say these can be
> renamed to (say) ISS_SERIAL_CONSOLE and AMIGA_BUILTIN_SERIAL_CONSOLE.

And, looking at it again, in */iss/console.c it can just as well be
dropped, as SERIAL_CONSOLE will always be set for that platform. So the
only actual usage I see is in */amiserial.c.


Paul Bolle

