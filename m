Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0FCNZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:25:38 -0400
Received: from ozlabs.org ([203.10.76.45]:56942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab0FCNZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:25:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jon Masters <jonathan@jonmasters.org>
Subject: modules: remove -w option (ie. !O_NONBLOCK)?
Date: Thu, 3 Jun 2010 22:55:32 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006032255.33101.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

   Since waiting module removal was never implemented in modprobe, I wonder
if we should simply get rid of it?  (It's implemented in rmmod only).
Unused code is buggy code, and there doesn't seem to be a demand for removing
modules "at some time in the future".

Thoughts?
Rusty.
