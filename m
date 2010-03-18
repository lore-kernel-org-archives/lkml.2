Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0CRDbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 23:31:50 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:54136 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CRDbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 23:31:49 -0400
Subject: PROBLEM: 2.6.33-rt7 crash under KVM
From: Jon Masters <jonathan@jonmasters.org>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 17 Mar 2010 23:31:46 -0400
Message-ID: <1268883106.18098.2054.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I like to run an RT test kernel under KVM (I am aware of latency issues,
this is just for development). The latest 2.6.33-rt7 kernel has been
crashing on X startup occasionally. I didn't have anything listening to
the virtual serial console before but now have minicom attached to the
host pts, so the next time it falls over I will post the backtrace.

Jon.


