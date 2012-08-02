Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2HBHUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:20:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2HBHUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:20:01 -0400
Date: Thu, 02 Aug 2012 00:20:00 -0700 (PDT)
Message-Id: <20120802.002000.2023014747210925552.davem@davemloft.net>
To: tim.gardner@canonical.com
Cc: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        ben@decadent.org.uk, JBottomley@Parallels.com,
        dan.j.williams@intel.com, divy@chelsio.com, netdev@vger.kernel.org
Subject: Re: [PATCH] firmware: Remove obsolete Chelsio cxgb3 firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1343848670-31504-1-git-send-email-tim.gardner@canonical.com>
References: <1343848670-31504-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed,  1 Aug 2012 13:17:50 -0600

> The current firmware version used by the device driver
> is 7.12.0
> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Divy Le Ray <divy@chelsio.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

"git am" refuses to apply this to current 'net':

Applying: firmware: Remove obsolete Chelsio cxgb3 firmware
error: removal patch leaves file contents
error: firmware/cxgb3/t3fw-7.10.0.bin.ihex: patch does not apply
