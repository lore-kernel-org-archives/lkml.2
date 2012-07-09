Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2GIG6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:58:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58209 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2GIG6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:58:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120707091447.25d735e3@pixies.home.jungo.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
 <4FF4005E.1070106@nod.at> <20120704143339.513439b4@pixies.home.jungo.com>
 <CACQ1gAhm-EsNPpDW26NSf-LJnxvJf0Y+tOnR9ZKPYdT_adPp7g@mail.gmail.com> <20120707091447.25d735e3@pixies.home.jungo.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 9 Jul 2012 08:58:28 +0200
Message-ID: <CACQ1gAjFGTZ8DriQ_4fU0GWKZ24xbfn_Jus38CgPvjdPFypnkw@mail.gmail.com>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/7 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> Many thanks for testing.
>
> Could you please verify the crash only occurs with the patch?
>
> Can you provide the vmlinux matching this oops, so I may analyze the
> exact null dereferencing point?
> It seems to be somewhere in ubi_wl_init, however the patch seems not to
> affect these parts of ubi...

Hi !
I can't reproduce it...
Maybe the problem was between the chair and the keyboard.
Anyway, if I ran into it again, I'll let you know.

Richard.
