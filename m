Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab1EaSFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:05:16 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:44507
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486Ab1EaSFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:05:14 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 14:05:13 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p4VHvig2015552
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: linux-kernel@vger.kernel.org
Subject: [3.0-rc1] i915: blank screen on Lenovo Ideapad U160
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 31 May 2011 19:57:43 +0200
Message-ID: <gi1uzevjl4.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Tue, 31 May 2011 19:57:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tested 3.0.0-rc1 on my notebook which has never been the best friend
of the i915 driver.  With linux-2.6.38-gentoo-r4 it has the problem
that the screen remains blank after the lid is closed and reopened, but
that problem I can live with.  With 3.0.0-r1 I am back to a former
problem that the screen goes (and remains) blank while booting.

The next step I will do is to test linux-2.6.39-gentoo, probably I
did not notice information that I have to adjust boot parameters or the
kernel config?

Best regards,

Dirk
