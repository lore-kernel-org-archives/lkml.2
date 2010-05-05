Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab0EEINv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:13:51 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40988 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab0EEINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:13:46 -0400
Date: Wed, 5 May 2010 10:13:42 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jarkko Nikula <jhnikula@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #15590] 2.6.34-rc1: regression: ^Z no longer stops sound
Message-ID: <20100505081342.GF30801@buzzloop.caiaq.de>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
 <8VO9AsMlpMD.A.H_B.XKJ4LB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8VO9AsMlpMD.A.H_B.XKJ4LB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 11:21:14PM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15590
> Subject		: 2.6.34-rc1: regression: ^Z no longer stops sound
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2010-03-14 7:58 (52 days old)
> Message-ID	: <20100314075831.GA13457@elf.ucw.cz>
> References	: http://marc.info/?l=linux-kernel&m=126855353122623&w=2

According to alsa-devel, this is fixed by 0f17014b.

