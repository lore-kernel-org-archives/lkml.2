Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0DTEDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:03:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0DTEAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:00:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Shirley Ma" <mashirle@us.ibm.com>, "Shirley Ma" <xma@us.ibm.com>,
       "=?utf-8?q?Thomas=20M=C3=BCller?=" <thomas@mathtm.de>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.sRH.jRSzLB@tosh>
Subject: [Bug #15719] virtio_net causing kernel BUG when running under VirtualBox
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15719
Subject		: virtio_net causing kernel BUG when running under VirtualBox
Submitter	: Thomas Müller <thomas@mathtm.de>
Date		: 2010-03-27 14:32 (24 days old)
First-Bad-Commit: http://kernel.org/git/linus/9ab86bbcf8be755256f0a5e994e0b38af6b4d399
Message-ID	: <4BAE1707.2050803@mathtm.de>
References	: http://marc.info/?l=linux-kernel&m=126970039227740&w=4
Handled-By	: Shirley Ma <mashirle@us.ibm.com>


