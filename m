Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2FZAUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:20:51 -0400
Received: from nat.fw1.corp.phx1.mozilla.net ([63.245.216.64]:57192 "EHLO
	zmmta2.mail.corp.phx1.mozilla.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757244Ab2FZAUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:20:50 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2012 20:20:50 EDT
Date: Mon, 25 Jun 2012 17:10:57 -0700 (PDT)
From: Martin Rosenberg <mrosenberg@mozilla.com>
To: linux-kernel@vger.kernel.org
Message-ID: <443195725.4576626.1340669457668.JavaMail.root@mozilla.com>
In-Reply-To: <1974638847.4574239.1340667841898.JavaMail.root@mozilla.com>
Subject: perf report does not get along with perf record -A
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.77.200]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working under the assumption that if I want to collect statistics from multiple runs of a program, I can do this by running
perf record prog; perf record -A prog; perf record -A prog

I've found that running perf record twice results in perf report hanging, and running it more than twice results in perf report first spewing a message about invalid formats, then crashing.
A log of the session, as well as the binary, its input and perf.data can be found at:

http://www.club.cc.cmu.edu/~mjrosenb/ion/perf_crash.tar.gz

Thanks --Marty
