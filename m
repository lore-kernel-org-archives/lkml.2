Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0KFEHC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 00:07:02 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:40451
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0KFEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 00:06:58 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Nov 2010 00:06:58 EDT
Date: Sat, 6 Nov 2010 04:01:02 +0000 (UTC)
From: houston.jim@comcast.net
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        mathieu desnoyers <mathieu.desnoyers@efficios.com>,
        dhowells@redhat.com, loic minier <loic.minier@linaro.org>,
        tglx@linutronix.de, peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, jim houston <jim.houston@comcast.net>,
        paulmck@linux.vnet.ibm.com
Message-ID: <271637926.861284.1289016062732.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
In-Reply-To: <1103753684.861128.1289015433137.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
Subject: Re: dyntick-hpc and RCU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [96.233.39.79]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Everyone,

Joe Korty posted the most recent forward port of my alternative RCU
patch to LKML today with the title "[PATCH] a local-timer-free version of RCU".
You can find it archived here:
    http://marc.info/?l=linux-kernel&m=128899396532086&w=2


Jim Houston
