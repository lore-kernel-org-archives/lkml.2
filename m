Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2GZVHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:07:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44024 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GZVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:07:35 -0400
MIME-Version: 1.0
In-Reply-To: <1343294151-5691-1-git-send-email-hauke@hauke-m.de>
References: <1343294151-5691-1-git-send-email-hauke@hauke-m.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jul 2012 14:07:14 -0700
X-Google-Sender-Auth: WHf4kD_VuDZMgLIlJZU_MYcYfFo
Message-ID: <CA+55aFySBN=ajj=XKRzehw-_aVOOgLfoq9g5T9Wxht8nrQBSZA@mail.gmail.com>
Subject: Re: [PATCH] bcma: fix regression in pmu workaround reg masks
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, davem@davemloft.net,
        brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, pieterpg@broadcom.com,
        brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
        =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. For some reason I didn't see this email this morning, and grew
impatient and committed the patch without the sign-off and with a
different changelog.

My bad. Too much email.

Anyway, this is commit 1f03bf06e4e3 in my tree.

              Linus

On Thu, Jul 26, 2012 at 2:15 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This fixes a regression introduced in:
> commit b9562545ef0b13c0440ccd8d6dd4111fb77cb17a
...
