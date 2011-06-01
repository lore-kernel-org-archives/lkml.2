Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1FAPE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:04:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54996 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1FAPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:04:23 -0400
Message-ID: <4DE6549A.6070201@linux.vnet.ibm.com>
Date: Wed, 01 Jun 2011 10:02:50 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Brian King <brking@us.ibm.com>, kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/ipr.c: reorder error handling code to include
 iounmap
References: <1306851409-14963-1-git-send-email-julia@diku.dk>
In-Reply-To: <1306851409-14963-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


