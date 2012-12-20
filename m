Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2LTRpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:45:18 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55170 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2LTRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:45:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121220173548.GB4989@atomide.com>
References: <20121220163814.GA29557@quad.lixom.net> <CA+55aFxL47wxTyTzLdnoFV=trnrMAz=_7rhsQFjb+K_mvTCa9w@mail.gmail.com>
 <CAOesGMiZTF4gogCkU7eSaOydkX82wfWywkKBgCJo_-ZW0Ox4kw@mail.gmail.com> <20121220173548.GB4989@atomide.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 09:44:51 -0800
X-Google-Sender-Auth: 3mxPliV3cNmQuE46TKcZ_k6SeIw
Message-ID: <CA+55aFyhsXpB9-cS3-wbVojaTaiDq9jFe3bhbQrbzFpKHvMbJQ@mail.gmail.com>
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
To: Tony Lindgren <tony@atomide.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        maxime.ripard@free-electrons.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 9:35 AM, Tony Lindgren <tony@atomide.com> wrote:
>
> Looks like Linus already applied "ARM: OMAP: Fix build breakage due
> to missing include in i2c.c" that I had queued earlier.

Yeah, since it was my mis-merge, and I realized that I had entirely
missed the header file fixup, I felt like I had to correct it since I
had the report and the pointer to the fix..

            Linus
