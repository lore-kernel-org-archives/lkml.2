Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2AaWDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:03:43 -0500
Received: from plane.gmane.org ([80.91.229.3]:34802 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab2AaWDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:03:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: cfq bug still not fixed on x86
Date: Tue, 31 Jan 2012 14:03:21 -0800
Message-ID: <4F286529.1060407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
X-Gmane-NNTP-Posting-Host: adsl-69-234-188-161.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20120106 Thunderbird/9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys.  Linus recently commited this bugfix from Jens:

commit 54b466e44b1c7809144bbd8cd6be3f85877ca46f
Author: Jens Axboe
Date:   Tue Jan 17 21:26:11 2012 +0100

    cfq-iosched: fix use-after-free of cfqq

That fixed the problem on my amd64x2 machine, but my old UP x86 amd
machine is still producing the same backtrace when udevd segfaults
during bootup.

I'm wondering if the patch neglects some 32-bit or non-SMP code?

Thanks for all your hard work on open-source :)

