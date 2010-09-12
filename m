Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0ILSeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:34:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0ILSee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:34:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Chuck Ebbert" <cebbert@redhat.com>, "Takashi Iwai" <tiwai@suse.de>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
In-Reply-To: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <0c5PAlgnPrH.A.UMB.3rRjMB@chimera>
Subject: [Bug #17742] 2.6.36-rc2-git5: Oops in snd_pcm_substream_proc_status_read()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 20:14:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17742
Subject		: 2.6.36-rc2-git5: Oops in snd_pcm_substream_proc_status_read()
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2010-09-01 8:19 (12 days old)
Message-ID	: <20100901041924.23a8a865@katamari>
References	: http://marc.info/?l=linux-kernel&m=128332930703451&w=2
		  https://bugzilla.redhat.com/show_bug.cgi?id=628404
		  https://bugzilla.redhat.com/show_bug.cgi?id=628404#c5
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: http://mailman.alsa-project.org/pipermail/alsa-devel/2010-September/031275.html


