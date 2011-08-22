Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HVV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:56:00 -0400
Received: from www85.your-server.de ([213.133.104.85]:51440 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1HVVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:55:57 -0400
X-Greylist: delayed 1453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Aug 2011 17:55:57 EDT
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
To: Remy Bohmer <linux@bohmer.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] accessfs-2.6.38-0.25 forward ported to linux-3.0, and fix build (seems also valid for 2.6.38)
References: <CANqCtQL+CAkaCGfXqMK67w0QTUdf_VmhMJKdGATBHabzgedAMQ@mail.gmail.com>
Date: Mon, 22 Aug 2011 23:31:39 +0200
Message-ID: <87vctpw2tg.fsf@rat.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: webmaster@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Remy,

Remy Bohmer <linux@bohmer.net> writes:

> - accessfs-2.6.38-0.25-fix-build.patch: This patch has to be applied
> to make it compile on 3.0 when CONFIG_NET_HOOKS and CONFIG_ACCESS_FS
> both are NOT set.
> I expect that this fix-build patch has to be applied to the 2.6.38
> edition as well, since it results in unresolved externals that should
> be there on 2.6.38 as well.

Thanks for spotting. Unfortunately, I never tested this combination. :-(

Regards, Olaf
