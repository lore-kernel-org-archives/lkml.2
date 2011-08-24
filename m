Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab1HXOM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:12:29 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43274 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751030Ab1HXOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:12:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y6QDiS8VM1mY9WMMev7eoR4qMkvIvjp6XC.CykO8BgbPlrx
 53o.p8zkwYTnUVHUQckl5GPA5t3QeDNBwVpnJVEAO2O1TJQBhSEw2bAHSJZg
 XFtD5HKMFiOR3JhlTKHIzLjmoD9kZvZe3MxYOeHe_CKZguhNKAcplvLt.Yus
 ynZub3XEwNNCKngX8RcnGEgYm9j.T54bEmhJwpXc1yZr4qrm5uBhzKEUYykM
 __KH9HqBNPhUWc75E3BXmHyyTbM0oZXAoO9vvotjqp_6EjtKv_WQkuVPeqpJ
 00MOgL3YS5fuztscufaKssgQcXqalGS8Mmd_TkgjXCT5Mx..aEqFjxQv3kDZ
 My1SxVvDahr2Fo_WygU2TN4JM.YUdNNvXiAjm_K85Bv9SVQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 09:12:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/13] dcache: convert dentry_stat.nr_unused to per-cpu
 counters
In-Reply-To: <1314089786-20535-3-git-send-email-david@fromorbit.com>
Message-ID: <alpine.DEB.2.00.1108240910440.24118@router.home>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com> <1314089786-20535-3-git-send-email-david@fromorbit.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Dave Chinner wrote:

> Before we split up the dcache_lru_lock, the unused dentry counter
> needs to be made independent of the global dcache_lru_lock. Convert
> it to per-cpu counters to do this.

I hope there is nothing depending on the counter being accurate.

Otherwise

Acked-by: Christoph Lameter <cl@linux.com>
