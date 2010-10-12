Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0JLSO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:14:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499Ab0JLSOZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au> <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Oct 2010 11:13:31 -0700
Message-ID: <AANLkTi=Rj+hmYthVcwYksSxUqFF+117FxVvdnuDCLxVY@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in debugfs"
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 7:53 AM, John W. Linville
<linville@tuxdriver.com> wrote:
>
> Please don't make me commit such an ugly patch...

 Why don't you just create a dummy inline ath_opmode_to_string() that
returns NULL in the non-debug case? The compiler will make the
conditionals all go away, and it will end up being "UNKNOWN" which is
just what you want. No?

                   Linus
