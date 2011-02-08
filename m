Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1BHBSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:18:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1BHBSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=u/U62TN1vm6+MXuwrT8xGDD5Koh+6j37rljBzAEEu7+0X1nO73Bnk8WrDlshDzsYAJ
         vA+RGel2f5NB4G8XEghDo992V0RY1j2LVsrzmKwzNvFnlmFJFOATn/PZ5IhjVdusGGpP
         MAd3lA35sJ7Ddq0GYii7KxhQwQi+ougdNcvzg=
MIME-Version: 1.0
In-Reply-To: <20110207154953.GN10564@opensource.wolfsonmicro.com>
References: <20110207152132.GM10564@opensource.wolfsonmicro.com>
 <Pine.LNX.4.44L0.1102071035320.1924-100000@iolanthe.rowland.org> <20110207154953.GN10564@opensource.wolfsonmicro.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 7 Feb 2011 17:17:59 -0800
X-Google-Sender-Auth: 1cwbc0wu15brE2AF0q55dCcZEJk
Message-ID: <AANLkTimh=8pSmQ6i-5H5+agSso7dCOcOrUJ6Uq_fu7nh@mail.gmail.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 7:49 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> I'm rather hoping that they'll notice the mailing list thread or that
> someone else who knows what's going on with them does

Surely you're joking. I mean, do _you_ scan every message that comes
through lkml and its various sister lists?

Do a git blame and add them to the CC:. It's the polite thing to do.
