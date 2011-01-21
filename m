Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1AUIGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:06:43 -0500
Received: from lo.gmane.org ([80.91.229.12]:59614 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1AUIGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:06:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] acpi: debugfs: fix buffer overflows, double free
Date: Fri, 21 Jan 2011 08:06:22 +0000 (UTC)
Message-ID: <ihbepu$jbj$2@dough.gmane.org>
References: <1295554086-23873-1-git-send-email-segoon@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 123.125.1.164
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-acpi@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 23:08:06 +0300, Vasiliy Kulikov wrote:

> File position is not controlled, it may lead to overwrites of arbitrary
> kernel memory.  Also the code may kfree() the same pointer multiple
> times.
> 
> One more flaw is still present: if multiple processes open the file then
> all 3 static variables are shared, leading to various race conditions.
> They should be moved to file->private_data.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

