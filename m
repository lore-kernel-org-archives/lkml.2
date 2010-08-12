Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab0HLUKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:10:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39337 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0HLUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=o0PwybjnJqep1tEG5jSr/l25gH+jg7+lsHZGW1sR0s4w+X45jv2XHj6TH0M7V6qWAl
         a/x3WJdpnQJhaAkqEhWnvwC7QyzR4pu/aoYz9E2U5aQXmpd6cW0D8NeBPiYcOMzTXcE9
         sPuNhtdzLSDTlhGqk1YcVmUuidrdQyaDKbHfs=
MIME-Version: 1.0
In-Reply-To: <201008122200.05598.thomas@m3y3r.de>
References: <201008122200.05598.thomas@m3y3r.de>
Date: Thu, 12 Aug 2010 23:10:15 +0300
X-Google-Sender-Auth: PlDWiSzWSQfVpH-bzXZD-vkPYE0
Message-ID: <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
Subject: Re: 2.6.36: Sound stop working
From: Pekka Enberg <penberg@kernel.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 11:00 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> My sound card stop to work since a few commits. I tried to bisect it and ended up with this:
>
> There are only 'skip'ped commits left to test.
> The first bad commit could be any of:
> 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e
> c1e5c954020e123d30b4abf4038ce501861bcf9f
> We cannot bisect more!
>
> any ideas what to do now?

Takashi, maybe this is related to Linus' problem?
