Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1AaNUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:20:16 -0500
Received: from www.tglx.de ([62.245.132.106]:59149 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab1AaNUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:20:13 -0500
Message-Id: <20110131131707.795836437@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 31 Jan 2011 13:19:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: [patch 0/3] mn10300: Cleanup time and timer related code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes stale code and switches the clocksource/events
code to generic functions.

Thanks,

	tglx



