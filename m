Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab0CRSzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0CRSzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:55:08 -0400
Date: Thu, 18 Mar 2010 19:53:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] never check task->signal != NULL
Message-ID: <20100318185301.GA18339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another preparation to make task->signal immutable, this is the only
necessary change outside of fork/exit pathes.

Oleg.

