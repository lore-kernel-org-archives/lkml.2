Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1IVXGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:06:49 -0400
Received: from peace.netnation.com ([204.174.223.2]:51905 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1IVXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:06:48 -0400
Date: Thu, 22 Sep 2011 16:06:47 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org
Subject: 3.1-rc6: wchan not working
Message-ID: <20110922230647.GC503@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without changing .config, /proc/x/wchan seems to now print "schedule" for
everything; eg, with 0x.ca/sim/ref/3.1-rc6-blue/config-3.1.0-rc6-blue+
as the .config. I'm currently bisecting a few other regressions as well,
but will add this to the list, unless it's obvious to anyone...

Simon-
