Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0KTCjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:39:00 -0500
Received: from hera.cwi.nl ([192.16.191.8]:50749 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0KTCi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:38:59 -0500
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 21:38:59 EST
Date: Sat, 20 Nov 2010 03:15:19 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: ide boot failure 2.6.36/2.6.28 - 2.6.27 works
Message-ID: <20101120021515.GA3277@iq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case anybody is still interested in this old IDE stuff:
I wanted to boot a recent kernel on an old machine and failed.
The last kernel that worked was 2.6.27.
What goes wrong is that the disks are no longer detected on 2.6.28.
I see that 2.6.28 had a lot of changes in this area.
Maybe this just needs a new boot option I overlooked.
(Or is oldfashioned IDE considered broken these days?)

Google gives me many people with the same problem
(e.g., http://bugs.gentoo.org/253628) but no remedy.
I have not looked at the code yet.

Andries
