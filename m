Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2GaJ32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:29:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44719 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2GaJ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <5017A053.9000206@parallels.com>
References: <500D09C9.7060903@parallels.com>
	<500D1116.7070301@parallels.com>
	<CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
	<50179CF0.7050200@parallels.com>
	<CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
	<5017A053.9000206@parallels.com>
Date: Tue, 31 Jul 2012 11:29:25 +0200
Message-ID: <CAFLxGvy396+BfYSaSnvAwJb0GO4WZCKbPXSbU7YfrOJTo6zk6A@mail.gmail.com>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "criu@openvz.org" <criu@openvz.org>,
        "users@openvz.org" <users@openvz.org>,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 11:07 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> Sorry :( However, if you can help with patches on that issue that would be
> highly appreciated :)
>

Yeah, but I fear it's not that easy.
We'd have to change crtools to work without ptrace().

-- 
Thanks,
//richard
