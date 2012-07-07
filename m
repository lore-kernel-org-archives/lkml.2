Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2GGB7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:59:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2GGB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:59:06 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=B5zKYH921dABKV2Z1VAA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [ANNOUNCE] 3.2.22-rt34
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jul 2012 21:58:58 -0400
Message-ID: <1341626338.18602.1.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.22-rt34 stable release.


This release is just an update to the new stable 3.2.22 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: af3e91ebefe263747fd12212491d1a2dc3ef9ccc


Or to build 3.2.22-rt34 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.22-rt34.patch.xz



Enjoy,

-- Steve



