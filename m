Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2DAOzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 10:55:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39082 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751731Ab2DAOzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 10:55:05 -0400
Message-ID: <1333292103.9225.1.camel@joe2Laptop>
Subject: Re: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 01 Apr 2012 07:55:03 -0700
In-Reply-To: <CAPXgP12nMmNwN6-T-2sCsv++-5qyZNokkZFLRQ5LpuwgmuaBWA@mail.gmail.com>
References: <20120329164842.GE28941@google.com>
	 <1333044612.15602.4.camel@joe2Laptop>
	 <CAOS58YOWA9U3Esb2535v_iivPaXeFYYS3nWd2KKF1=MsfZ0Piw@mail.gmail.com>
	 <1333051616.15602.23.camel@joe2Laptop>
	 <CAOS58YMjB4HrNOxWMjm=EKqZNd9QmK+QjSv2EfMbYs9MKk+-tA@mail.gmail.com>
	 <CAPXgP12nMmNwN6-T-2sCsv++-5qyZNokkZFLRQ5LpuwgmuaBWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 15:29 +0200, Kay Sievers wrote:
> The kernel's printk() uses a static scratch buffer of 1024 chars. The
> prototype for the printk() with facility and structure support I have,
> does a bit better and more reliable 'buffered IO' than the current
> one.

Can you send me a link to your code please?


