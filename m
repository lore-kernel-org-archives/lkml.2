Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2HXEZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:25:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:23107 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2HXEZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:25:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="184849912"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: RE: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Thread-Topic: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Thread-Index: AQHNgPi7ZJFyDkZcAUKuhoC56fsXb5doXm9A
Date: Fri, 24 Aug 2012 04:25:15 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD23EFED@BGSMSX102.gar.corp.intel.com>
References: <1345686558-16512-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120823063005.GL15548@intel.com>
In-Reply-To: <20120823063005.GL15548@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

> On Thu, Aug 23, 2012 at 07:19:18AM +0530, Ramakrishna Pallala wrote:
> > This patch checks for charger status register for determining the
> > battery charging status and reports Discharing/Charging/Not
> > Charging/Full accordingly.
> >
> > This patch also adds the interrupt support for Safety Timer Expiration.
> > This interrupt is helpful in debugging the cause for charger fault.
> >
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I got the Ack from Mika can you look into this patch.

Also I have submitted another patch which needs your attention.
[PATCH v2] power_supply: Added helper function to get the ps object from supplied_to list

Thanks,
Ram
