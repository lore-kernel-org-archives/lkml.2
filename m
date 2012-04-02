Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2DBWvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:51:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46286 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2DBWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:51:46 -0400
Date: Mon, 2 Apr 2012 18:47:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: suresh.b.siddha@intel.com, mingo@elte.hu
Subject: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
Message-ID: <20120402224701.GA6961@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F7A2D7B.0065,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

The git commit 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 has CC stable@kernel.org
but it breaks Xen - we are working to fix it in 3.4, but the fix for it
does some architectual changes (136d249ef7dbf0fefa292082cc40be1ea864cbd6) that
I don't know if you are comfortable putting in stable tree.


