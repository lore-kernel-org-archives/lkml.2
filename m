Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1EDIVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:21:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:37931 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1EDIVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="430182003"
Message-Id: <20110504081725.946950281@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 16:17:25 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, jgarzik@pobox.com,
        hch@infradead.org, djwong@us.ibm.com
Subject: [patch v2 0/3] block: optimize flush for non-queueable flush drive
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush request isn't queueable. When it's running, other request
can't. We can optimize flush performance according to this knowledge
In my test, I got about 20% performance boost.
