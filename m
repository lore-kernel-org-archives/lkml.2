Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2GZU7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:59:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47289 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2GZU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:59:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
References: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jul 2012 13:58:40 -0700
X-Google-Sender-Auth: BsrzPn2so5vKNjnbbSOlAH_bgiw
Message-ID: <CA+55aFxrbbbC9eSCCh=s1mrNk=bz=og2B-FxmoYpVuxVvMrRqQ@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO changes for v3.6
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 3:48 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> in Grants absence, these are my queued and -next-tested changes
> for v3.6, please pull them in. Grants "merge" branch prior to his
> absence was merged in as a base for this patch series.

Please verify my conflict resolution in drivers/gpio/gpio-mxc.c.

The resolution seemed pretty straight-forward, but I obviously didn't
test the result, so it would be best to double-check,

             Linus
