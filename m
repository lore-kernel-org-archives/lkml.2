Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0LJO4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:56:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab0LJO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:56:20 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        czoccolo@gmail.com
Subject: Re: [patch]block cfq: select new workload if priority changed
References: <1291871853.2323.8.camel@sli10-conroe>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 10 Dec 2010 09:56:14 -0500
In-Reply-To: <1291871853.2323.8.camel@sli10-conroe> (Shaohua Li's message of
	"Thu, 09 Dec 2010 13:17:33 +0800")
Message-ID: <x49sjy5ad81.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> If priority is changed, continue checking workload_expires and service tree
> count of previous workload is meaningless. We should always choose the workload

I'd change that first sentence to:

  If priority is changed, continuing to check workload_expires and
  service tree count of the previous workload does not make sense.

> with lowest key of new priority in such case.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

This makes sense to me.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
