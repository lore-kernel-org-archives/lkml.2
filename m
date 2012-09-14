Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab2INSIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:08:45 -0400
Received: from mail.digium.com ([216.207.245.2]:50982 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab2INSIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:08:44 -0400
Date: Fri, 14 Sep 2012 13:01:32 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH v2 1/3] edac_mc: fix kfree calls in the error path
Message-ID: <20120914180132.GC18672@digium.com>
References: <1345349484-31552-1-git-send-email-sruffell@digium.com>
 <1347645498-21215-1-git-send-email-sruffell@digium.com>
 <1347645498-21215-2-git-send-email-sruffell@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347645498-21215-2-git-send-email-sruffell@digium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:58:16PM -0500, Shaun Ruffell wrote:
> From: Fengguang Wu <fengguang.wu@intel.com>
> 
> From: Fengguang Wu <fengguang.wu@intel.com>
 
Darn it. If you push this through, mind fixing the above?
