Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2BFOvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:51:53 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:31791 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754965Ab2BFOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:51:52 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XrT2tM4VM1n33gsRGu4oVESldItC1NCCWWbmaN57yfVqFs.
 9CY5qWsm0KSXjXZPyjAZ7Q5_n.dOnH4AWURo6omGHyg5UfqECQXGEQRP5O1z
 RjYGuWun66pq0N1_B4KKTutk2Ev2DUDqZ15pOjZdUWmzJx6eHUj39_Y5aj_y
 f_MVwRLQ.JnG0AhMv22FNtVZ9_X.KEqHj9wSvBn6vYwY5Y69WU4m4okJ9Rai
 48j6Olk8VLyKgCb34kyvkN_lB36iarct1cu3SgVmmeSL12T1pwafSkUvrOWo
 _fBJtnuytgjUZbYeouwztyb_zDpwYQ7DMHw7DBd7nVfDL_fntNHJI_IxCokA
 yaRAsfr2UxX_ZH041A2urJGkrmG4xnDzLC.yQsLBuX82DROU.folfxbZd5du
 zCHkYj7kzDUtHu.SU0IY2w0upeDiGqTSWi2w-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 6 Feb 2012 08:51:48 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Young <dyoung@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, xiyou.wangcong@gmail.com,
        penberg@kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH 2/3] move slabinfo.c to tools/vm
In-Reply-To: <20120205081550.GA2247@darkstar.redhat.com>
Message-ID: <alpine.DEB.2.00.1202060851260.393@router.home>
References: <20120205081550.GA2247@darkstar.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012, Dave Young wrote:

> We have tools/vm/ folder for vm tools, so move slabinfo.c
> from tools/slub/ to tools/vm/

Acked-by: Christoph Lameter <cl@linux.com>
