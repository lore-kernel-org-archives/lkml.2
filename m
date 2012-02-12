Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963Ab2BLGur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 01:50:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64910 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2BLGuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 01:50:46 -0500
Date: Sat, 11 Feb 2012 22:50:40 -0800
From: Dong Aisheng <dongas86@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Dong Aisheng <dong.aisheng@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/1] dt: add of_get_child_count helper function
Message-ID: <20120212065040.GA2031@b29396-Latitude-E6410>
References: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org>
 <4F36D19A.8050409@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F36D19A.8050409@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 12:37:46AM +0400, Sergei Shtylyov wrote:
> >diff --git a/include/linux/of.h b/include/linux/of.h
> >index a75a831..ae242ef 100644
> >--- a/include/linux/of.h
> >+++ b/include/linux/of.h
> >@@ -195,6 +195,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
> >  	for (child = of_get_next_child(parent, NULL); child != NULL; \
> >  	     child = of_get_next_child(parent, child))
> >
> >+static inline int of_get_child_count(const struct device_node *np)
> >+{
> >+	struct device_node *child = NULL;
> >+	int num = 0;
> >+
> >+	while ((child = of_get_next_child(np, child)) != NULL)
> 
>    Doesn't scripts/checkpatch.pl complain here?
> 
That complain actually is not caused by this patch.
I have already sent a patch to fix that issue.
But seemed to get a NACK.
Please refer to:
https://lkml.org/lkml/2011/12/20/236

Regards
Dong Aisheng
