Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1CGJmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:42:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37523 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1CGJml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:42:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] page-types.c: add a new argument of debugfs path
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <1299487900-7792-1-git-send-email-gong.chen@linux.intel.com>
References: <1299487900-7792-1-git-send-email-gong.chen@linux.intel.com>
Message-Id: <20110307184133.8A19.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 18:42:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> page-types.c doesn't supply a way to specify the debugfs path and
> the original debugfs path is not usual on most machines. Add a
> new argument to set the debugfs path easily.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>

Hi

Why do we need to set debugfs path manually? Instead I'd suggested to
read /proc/mount and detect it automatically.

Thanks.



