Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab1J1VUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:20:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55489 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab1J1VUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <m2fwide1ai.fsf@bob.laptop.org>
References: <m2fwide1ai.fsf@bob.laptop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Oct 2011 14:20:17 -0700
X-Google-Sender-Auth: qBvs7Fiajvi54fd2_Ozkn_R81qU
Message-ID: <CA+55aFwwEVCVTdFKSb3Rszb-s90fV3ocOWrbevrhYJV8X6bWog@mail.gmail.com>
Subject: Re: MMC updates for 3.2-rc1
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 5:41 AM, Chris Ball <cjb@laptop.org> wrote:
>
> Does the below method of verifying a signed pull request work well for you?

This kind of GPG-signed thing works well (with explicit BEGIN PGP
SIGNED MESSAGE quoting).

Not that you even need it, since it's on git.kernel.org, so it's
doubly verified.

Pulled,

                       Linus
