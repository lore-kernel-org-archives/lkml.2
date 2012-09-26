Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2IZOpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:45:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2IZOp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:45:28 -0400
Message-ID: <50631501.7020706@kernel.dk>
Date: Wed, 26 Sep 2012 16:45:21 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.7
References: <20120926135855.GA6685@phenom.dumpdata.com>
In-Reply-To: <20120926135855.GA6685@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-26 15:58, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> I've one more patch (a small change) that I was hoping you could
> pull in your v3.7 branch.
> 
> The branch is:
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.7
> 
> and has this tiny patch:
> 
> Oliver Chick (1):
>       xen/blkback: Change xen_vbd's flush_support and discard_secure to have type unsigned int, rather than bool

Pulled.

-- 
Jens Axboe

