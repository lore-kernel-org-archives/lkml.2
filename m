Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2EXDOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:14:21 -0400
Received: from mail.snarked.org ([67.43.172.250]:39273 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008Ab2EXDOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:14:20 -0400
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: Mounting /proc w/ kernel 3.4.0 - "uid" parameter no longer valid?
Date: Wed, 23 May 2012 20:08:42 -0700
Message-ID: <jpk8nr$2f8$1@snarked.org>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3538.513
X-Newsreader: Microsoft Windows Live Mail 15.4.3538.513
Importance: Normal
X-Priority: 3
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc:  unrecognized mount option "uid=1" or missing value

This works under 3.3.6 and earlier (I never tried 3.3.7).  It appears that the 
"uid" mount option was removed.  WHY?  More importantly, where is this change 
listed?  I didn't see it in the git log.

This is really bad as I rebooted a remotely colocated server and since the 
procfs is not mounted, I cannot log in via SSH to correct the problem.

OK, so there's not that much point in changing the UID of the procfs files, 
but I preferred to set their default ownership to a non-privileged user. 

