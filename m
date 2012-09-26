Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2IZOKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:10:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17333 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2IZOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:10:19 -0400
Date: Wed, 26 Sep 2012 09:58:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.7 
Message-ID: <20120926135855.GA6685@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

I've one more patch (a small change) that I was hoping you could
pull in your v3.7 branch.

The branch is:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.7

and has this tiny patch:

Oliver Chick (1):
      xen/blkback: Change xen_vbd's flush_support and discard_secure to have type unsigned int, rather than bool

 drivers/block/xen-blkback/common.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
