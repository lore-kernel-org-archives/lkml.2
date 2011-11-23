Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1KWK1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:27:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1KWK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:27:52 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.4.235]
In-Reply-To: <4ECC67B9.4050306@codeaurora.org>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com> <4ECC67B9.4050306@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 23 Nov 2011 12:27:31 +0200
Message-ID: <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 5:25 AM, Saravana Kannan <skannan@codeaurora.org> wrote:
> Sorry for the rant, this naming just rubs me the wrong way. I definitely
> appreciate the idea behind these patches.

I don't share the same naming concerns you have (if any, then
confusion with the bluetooth AMP patches and prefixes is more of a
concern to me), but I don't care deeply about names.

Feel free to offer a different name, though really 'amp' here only
describes the general model and motivation and is rarely used
throughout the code; we mostly either use 'remoteproc' or 'rpmsg',
which respectively refer to the two frameworks that are being added
(the former responsible for controlling the state of the remote
processors, and the latter for communicating with them).

Thanks,
Ohad.
