Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1GGPqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:46:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62376 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab1GGPqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:46:13 -0400
Date: Thu, 7 Jul 2011 18:45:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3] staging: zcache: support multiple clients, prep for
 KVM and RAMster
Message-ID: <20110707154500.GN18655@shale.localdomain>
References: <02fef1b5-2944-4c86-87db-20dcc6352c28@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02fef1b5-2944-4c86-87db-20dcc6352c28@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 07:37:19AM -0700, Dan Magenheimer wrote:
> Hi Greg --
> 
> This version (v3) corrects the array bounds/walking code as
> noted by Dan Carpenter.  I think this patch is now ready for
> staging-next and for merging when the 3.1 window opens.
> 
> Thanks,
> Dan

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

