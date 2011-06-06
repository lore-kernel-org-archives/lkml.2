Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1FFJFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:05:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab1FFJFW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110606033900.GF26101@linux-sh.org>
References: <20110606033900.GF26101@linux-sh.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Jun 2011 18:04:58 +0900
Message-ID: <BANLkTik1nLG6f27JkR0kBvcJEoqUrq602A@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev fixes for 3.0-rc2
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:39 PM, Paul Mundt <lethal@linux-sh.org> wrote:
>
> Bruno PrÃƒÆ’Ã‚Â©mont (1):
>      video: Fix use-after-free by vga16fb on rmmod

Do you even *look* at what you ask me to pull from you?

Spend a bit of effort in not sending obviously bogus and corrupted
authorship patches. That one has Bruno's name correctly in the
sign-off, but you've done something horrible to it in the authorship.

                  Linus
