Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab1JCU5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:57:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1JCU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <1317653420-21404-3-git-send-email-mason@myri.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Oct 2011 13:56:50 -0700
X-Google-Sender-Auth: NtlRgwgmbqxZUZeN6byauW6C1Ec
Message-ID: <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
To: Jon Mason <mason@myri.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 7:50 AM, Jon Mason <mason@myri.com> wrote:
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Acked-by: Jon Mason <mason@myri.com>

You need to sign off on this one too, since you're passing it on.

Also, I'd *really* like some more acks/reviews on the series. Anybody?

                    Linus
