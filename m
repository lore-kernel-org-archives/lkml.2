Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0JHATf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:19:35 -0400
Received: from trent.utfs.org ([194.246.123.103]:58597 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab0JHATe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:19:34 -0400
Date: Thu, 7 Oct 2010 17:19:31 -0700 (PDT)
From: lists@nerdbynature.de
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: LKML <linux-kernel@vger.kernel.org>, takedakn@nttdata.co.jp,
        haradats@gmail.com
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
In-Reply-To: <201010080010.o980ADB8027880@www262.sakura.ne.jp>
Message-ID: <alpine.DEB.2.01.1010071717590.21082@trent.utfs.org>
References: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org> <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org> <201010080010.o980ADB8027880@www262.sakura.ne.jp>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 at 09:10, Tetsuo Handa wrote:
> Linux 2.6.36 includes TOMOYO 2.3 which is not compatible with
> TOMOYO 2.2 included in Linux 2.6.30-2.6.35 .

Yes, that's what I found out now, see my other reply to this thread.

Thanks for the quick reply & again: sorry for the noise...

Christian.
-- 
BOFH excuse #189:

SCSI's too wide.
