Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1DAItH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:49:07 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:63078 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab1DAItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:49:02 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 04:49:02 EDT
X-IronPort-AV: E=Sophos;i="4.63,281,1299452400"; 
   d="scan'208";a="104204826"
Date: Fri, 1 Apr 2011 10:39:02 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: hurd 0.401 is released!
Message-ID: <20110401083902.GE4963@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There are rumors that Duke Nukem Forever will actually be released in
Apr^WMa^WJune 2011, so there's no escape for the Hurd any more, we had
to finish and release. There has been considerable progress lately,
so it is with great pleasure that the Hurd maintainers team decided
to release version 0.401 of the GNU/Hurd Operating System. As the
version number and image size suggest, this is only a small preview
of course, but we expect GNU/Hurd to be of production-quality within
the third millenium, to be sure.

A LiveCD demo is available on
http://people.debian.org/~sthibault/hurd-0.401/hurd-0.401.iso
and can be trivially tried using
qemu -cdrom hurd-0.401.iso

We hope that you will appreciate its features and speed.

Are you interested in contributing to the GNU Hurd project?  Just
request an shell account on one of our servers and get started.

http://www.gnu.org/software/hurd/public_hurd_boxen.html

It is also worth noting that like in previous years, GNU/Hurd runs
for the GSoC program, details can be found on

http://www.gnu.org/software/hurd/community/gsoc.html
