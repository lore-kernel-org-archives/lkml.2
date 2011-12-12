Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1LLKBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:01:39 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:35947 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1LLKBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:01:36 -0500
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
From: Matt Fleming <matt@console-pimps.org>
To: Keith Packard <keithp@keithp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <8639cqjvyn.fsf@sumi.keithp.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
	 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
	 <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com>
	 <8639cqjvyn.fsf@sumi.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:01:23 +0000
Message-ID: <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 19:43 -0800, Keith Packard wrote:
> On Sun, 11 Dec 2011 19:32:51 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Could you share your configuration, please?
> 
> Of course.

How about the dmesg from a kernel with this revert applied?

-- 
Matt Fleming, Intel Open Source Technology Center

