Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2BJUGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760056Ab2BJUGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:06:38 -0500
Date: Fri, 10 Feb 2012 21:00:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] signal: force_sig cleanups
Message-ID: <20120210200004.GA20890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of force_sig/etc is almost always wrong outside
of do_trap-like paths, and this interface needs the fixes/
cleanups itself.

This series starts the necessary cleanups. Initially it had
one more patch, send_sig_all()->force_sig() is absolutely
wrong and should be replaced with SEND_SIG_FORCED too. But
this conflicts with other changes in tty.git, I need to
discuss this with Anton/Greg.

Oleg.

