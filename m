Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2JAJLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:11:37 -0400
Received: from smtp1.uu.se ([130.238.7.54]:51572 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab2JAJLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:11:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20585.24010.139220.512754@pilspetsen.it.uu.se>
Date: Mon, 1 Oct 2012 11:09:30 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap
In-Reply-To: <E1TIVdh-0007iT-00@www.xplot.org>
References: <E1TIVdh-0007iT-00@www.xplot.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Shepard writes:
 > This weekend I finally figured out why the keyboard in my MacBook Pro
 > stopped working between 3.4 and 3.5.
 > 
 > When I turned on CONFIG_EXPERT it turned off CONFIG_HID_APPLE.  There
 > was no warning that selecting "Configure standard kernel features" will
 > invisibly turn off needed things elsewhere in the configuration tree.
 > 
 > Something needs to be fixed, but it's not obvious that any simple change
 > will work without causing other troubles.

"diff" the before and after .config files.  That's alerted me to unexpected
changes (not just "where did CONFIG_${foo} go?" but also "wtf is CONFIG_${bar}
doing there?") on numerous occasions.
