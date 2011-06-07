Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab1FGSg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:36:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18978 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1FGSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:36:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thomas@shipmail.org,
        dri-devel@lists.freedesktop.org, Jerome Glisse <j.glisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH] fix spelling mistakes and clear up some wording.
Date: Tue,  7 Jun 2011 14:35:51 -0400
Message-Id: <1307471752-1248-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4DEE6F9D.0128:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on the DMA pool concept in the TTM code I re-read
everything once more to make sure I was not missing anything. Whilst doing
that I found some spelling mistakes and some wording that could be improved
a bit. So fixed it up and please consider this patch for 3.1.

