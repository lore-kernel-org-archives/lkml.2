Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0JWCaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:30:55 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:47391 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab0JWCax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:30:53 -0400
Date: Sat, 23 Oct 2010 04:30:52 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq@rere.qmqm.pl>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: Introduce a read-mostly percpu API
Message-ID: <20101023023052.GA20778@rere.qmqm.pl>
References: <20101023022545.GA18876@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101023022545.GA18876@rere.qmqm.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 04:25:45AM +0200, Micha³ Miros³aw wrote:
> Commit c957ef2c59e952803766ddc22e89981ab534606f that just went into
> Linus' tree has a bug - only one of hunks was modified (.readmostly
> moved after .page_aligned).

Ah. I just found another commit that fixes it. Sorry for the noise.

Best Regards,
Micha³ Miros³aw
