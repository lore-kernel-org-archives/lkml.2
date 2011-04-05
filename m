Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1DEUJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 16:09:38 -0400
Received: from messager.iut-bm.univ-fcomte.fr ([194.57.86.195]:57211 "EHLO
	messager.iut-bm.univ-fcomte.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505Ab1DEUJh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 16:09:37 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 16:09:36 EDT
From: Arnaud Giersch <arnaud.giersch@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/34] parport: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	<1302015561-21047-21-git-send-email-mmarek@suse.cz>
Date: Tue, 05 Apr 2011 22:00:14 +0200
In-Reply-To: <1302015561-21047-21-git-send-email-mmarek@suse.cz> (Michal
	Marek's message of "Tue, 5 Apr 2011 16:59:07 +0200")
Message-ID: <wwetyeclb8x.fsf@powwow.iut-bm.univ-fcomte.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mardi 05 avril 2011, vers 16:59:07 (+0200), Michal Marek a écrit :

> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
>
> Cc: Arnaud Giersch <arnaud.giersch@free.fr>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/parport/parport_ip32.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

I do not use this module anymore, but anyway...

Acked-by: Arnaud Giersch <arnaud.giersch@free.fr>

Arnaud
