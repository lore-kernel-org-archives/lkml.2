Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1FFQnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:43:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50078 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1FFQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTiko2A3bthjVL_NR0yaQP_8Nq5VmqQ@mail.gmail.com>
References: <20110606070553.9829.40823.stgit@ponder> <BANLkTiko2A3bthjVL_NR0yaQP_8Nq5VmqQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 10:43:27 -0600
X-Google-Sender-Auth: 7iXw2hA9ZFldKfywIK8vL7-KjU4
Message-ID: <BANLkTim+zhXktzjxi8FsEEXNxkj80BmdXA@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 10:29 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Jun 6, 2011 at 03:06, Grant Likely wrote:
>> Sort the gpio makefile and enforce the naming convention gpio-*.c for
>> gpio drivers.
>
> ml_ioh_gpio.c and pch_gpio.c use KBUILD_MODNAME with
> pci_request_regions, but i think that func only uses it for /proc/
> status info, so maybe it's ok ?

I'm also going to go out on a limb and say these are probably not a
problem, particularly because they are brand new drivers as of late
last year, but I'll let the Tomoyo weigh in on it (cc'd)

g.
