Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1E0CnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:43:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41643 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689Ab1E0CnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:43:13 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jaxboe@fusionio.com
Cc: snitzer@redhat.com, msb@chromium.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: dm: pass up rotational flag
Date: Thu, 26 May 2011 22:42:46 -0400
Message-Id: <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <4DDEA689.2090004@fusionio.com>
References: <4DDEA689.2090004@fusionio.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DDF0FBF.0127:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a tentative patch set for transitioning the non_rotational,
discard and secure discard queue flags to the topology information.

The first patch introduces a new function for setting the default limits
for stacking drivers like we discussed a few weeks ago.  Wrt. to naming
I felt it was best to have a function that said "stacking".  That's why
I introduced a new call instead of using blk_set_default_limits() even
though that function was originally motivated by device mapper.

The last two patches deal with non-rotational and the discard flags
respectively.

Let me know what you guys think...

-- 
Martin K. Petersen	Oracle Linux Engineering

