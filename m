Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1A1IZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:25:26 -0500
Received: from lo.gmane.org ([80.91.229.12]:47265 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab1A1IZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:25:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 2/4] net: Make NETCONSOLE_DYNAMIC use select CONFIGFS_FS
Date: Fri, 28 Jan 2011 08:25:10 +0000 (UTC)
Message-ID: <ihtuh6$921$3@dough.gmane.org>
References: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
	<1296155430-3796-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 11:10:28 -0800, Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Convert 'depends && SYSFS && CONFIGFS_FS' to 'select CONFIGFS_FS'
> 

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

