Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab0KQKjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:39:44 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56996 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751443Ab0KQKjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:39:43 -0500
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: 2.6.35.5: hibernation broken... AGAIN
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 17 Nov 2010 11:39:29 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171139.33398.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
the nasty memory-corrupting hibernation bug 
https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since 2.6.35.5.
2.6.35.4 works fine, 2.6.35.5 crashes after two days.

It seems to be caused by b77c254d8d66e5e9aa81239fedba9f3d568097d9.

-- 
Ondrej Zary
