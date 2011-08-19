Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HSAUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:20:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:20785 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1HSAUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:20:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,248,1312182000"; 
   d="scan'208";a="42870917"
Subject: Re: cfq-iosched: a regression
From: Shaohua Li <shaohua.li@intel.com>
To: Justin TerAvest <teravest@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>
In-Reply-To: <CAN5ZDdewpvg=82O69yGSXJczJMZrfqrLNS=RQiD2Ne2RqQTF1w@mail.gmail.com>
References: <1313462826.27321.22.camel@sli10-conroe>
	 <CAN5ZDdewpvg=82O69yGSXJczJMZrfqrLNS=RQiD2Ne2RqQTF1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 08:21:35 +0800
Message-ID: <1313713295.29510.1.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 04:22 +0800, Justin TerAvest wrote:
> Hi Shaohua,
> 
> What was the workload you were running to find this regression?
kernel build as I declared below.

Thanks,
Shaohua

> On Mon, Aug 15, 2011 at 7:47 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > We have a kernel build regression since 3.1-rc1, which is about 10%
> > regression. The kernel source is in an ext3 filesystem.
> > Alex Shi bisect it to commit:
> > commit a07405b7802691d29ab3b23bdc76ee6d006aad0b
> > Author: Justin TerAvest <teravest@google.com>
> > Date:   Sun Jul 10 22:09:19 2011 +0200
> >
> >    cfq: Remove special treatment for metadata rqs.
> >
> > Apparently this is caused by lack metadata preemption, where ext3/ext4
> > do use READ_META. I didn't see a way to fix the issue, so suggest
> > reverting the patch.
> >
> > Reported-by: Alex Shi<alex.shi@intel.com>
> > Reported-by: Shaohua Li<shaohua.li@intel.com>
> >
> >


