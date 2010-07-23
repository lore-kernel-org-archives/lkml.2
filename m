Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab0GWOEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:04:33 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:57271 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752381Ab0GWOEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:04:30 -0400
From: Dave Chinner <david@fromorbit.com>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, fmayhar@google.com, johnstul@us.ibm.com
Subject: [PATCH 0/2] vfs scalability tree fixes
Date: Sat, 24 Jul 2010 00:04:00 +1000
Message-Id: <1279893842-4246-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100723111310.GI32635@dastard>
References: <20100723111310.GI32635@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

Here's the fixes I applied to your tree to make the XFS inode cache
shrinker build and scan sanely.

Cheers,

Dave.

