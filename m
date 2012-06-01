Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965389Ab2FAQPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:15:51 -0400
Received: from tango.0pointer.de ([85.214.72.216]:34403 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965373Ab2FAQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:15:49 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2012 12:15:49 EDT
Date: Fri, 1 Jun 2012 18:05:31 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Matthew Garrett <mjg59@fedoraproject.org>
Subject: Timer woes on Lenovo Ideapad S10-3
Message-ID: <20120601160531.GA31365@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

Unless "highress=off" and "nohz=off" are passed to the kernel (3.3) my
Ideapad S10-3 freezes when coming back from system suspend. One of those
two options is not sufficient, only if both are specified together my
suspend/resume works properly. Apparently there's something wrong with
the timer setup when the system resumes?

Anything I can do to track this down?

Lennart
