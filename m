Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0H3RfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:35:07 -0400
Received: from n10.bullet.mail.ac4.yahoo.com ([76.13.13.238]:23727 "HELO
	n10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755539Ab0H3RfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:35:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 516907.8962.bm@omp128.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=PTa3C+ah5Wj1ME8wYBDgKw7f6E8uBqDL3eTFR/SEND+WMQctY3Zhcfq+xTAncl7qW8NtVzynl1RbZVpiedLtTMfvt3ntDvyjY5h6QBmTgV79IXjE+PPbojPHJ9LG/eby7JW0pnKR6s3Z29cIO/YsQv6Q5U1EM1KHSO0sHNm7AcI=;
Message-ID: <838632.57445.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: vJqsPzAVM1n9uRFn7IdXxGoKaGeMtwPgoS._qrK_zcBOoJN
 1wZyY8._IigkeTHK_BRw0SSFN3TfED3_4w1ysXfszqVcNqVaRhH9OI0tpOrF
 SEDbPtruBFfqR8HlP3IkxNc380w89hZq6v.JxfCerNR234.CYfbD7RFvklDj
 qIVKVc0SJNqxYDVXJXwOpZd111yAHDEewRlFnVYQBmlof_rIOBI5fjNjjwXQ
 hsQwNAzpaD2IqOfh.lTSKJ3XKdH1zzac_nAHF_2pj_59m_92XzF88YrXKitY
 eDzWj2o_TYDnTR3jj8x9FKB_wYeo7uq96iqb3CxBWK_gdv2vyHtunQiGMWw5
 3la8Ypf43RTILVHg-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 30 Aug 2010 10:35:02 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC PATCH] GPIO: add control of powerdown modes and pull-up/down configurations.
To: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
In-Reply-To: <1283154702-23008-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 8/30/10, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:

> From: MyungJoo Ham <myungjoo.ham@samsung.com>
> Subject: [RFC PATCH] GPIO: add control of powerdown modes and pull-up/down configurations.

NAK.

Note that Documentation/gpio.txt specifies such
pinmux/configuration as out of scope.  There isn't
even uniformity of models about such things between
SOCs (and ASICs etc).

Put these kinds of things in arch-specific code,
which has good reason to know about all the ways
each platform differs from others, and to cope.

Look at OMAP and AT91 for some examples of SOCs
which have addressed these issues cleanly, and
without committing mayhem on the GPIO framework.

