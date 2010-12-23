Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0LWPFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0LWPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:05:18 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        vgoyal@redhat.com
Subject: Re: [PATCH 1/2]block cfq: don't use atomic_t for cfq_queue
References: <1293072333.10593.21.camel@sli10-conroe>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 23 Dec 2010 10:05:13 -0500
In-Reply-To: <1293072333.10593.21.camel@sli10-conroe> (Shaohua Li's message of
	"Thu, 23 Dec 2010 10:45:33 +0800")
Message-ID: <x49vd2k7cnq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> cfq_queue->ref is used with queue_lock hold, so ref doesn't need to be an atomic
> and atomic operation is slower.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
