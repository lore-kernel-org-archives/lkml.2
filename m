Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2DDXqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:46:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48520 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753617Ab2DDXqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:46:17 -0400
Message-ID: <1333583176.23520.34.camel@joe2Laptop>
Subject: scsi/ufs: likely || misuse
From: Joe Perches <joe@perches.com>
To: Santosh Yaraganavi <santoshsy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Apr 2012 16:46:16 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably this should be && not ||

drivers/scsi/ufs/ufshcd.c:		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)


