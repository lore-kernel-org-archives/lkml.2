Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0I1RHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0I1RHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:07:18 -0400
Date: Tue, 28 Sep 2010 13:07:05 -0400
From: Dave Jones <davej@redhat.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Pavel Machek <pavel@ucw.cz>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Zaurus driver being loaded when it shouldn't.
Message-ID: <20100928170704.GA523@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Pavel Machek <pavel@ucw.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Dell Adamo laptop which has a wwan device which
is triggering zaurus.ko to get loaded, probably due to this
wildcard match..

 alias:          usb:v*p*d*dc*dsc*dp*ic02isc0Aip00*

Full lsusb -v is at http://davej.fedorapeople.org/usb


	Dave

