Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439Ab0I0N47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:56:59 -0400
Received: from mail.solarflare.com ([216.237.3.220]:28276 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386Ab0I0N4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:56:49 -0400
Subject: Re: [PATCH v11 12/17] Add a kconfig entry and make entry for mp
 device.
From: Ben Hutchings <bhutchings@solarflare.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
In-Reply-To: <0eed02838e581f2ef2247be8e69bc34cdecce6b2.1285385607.git.xiaohui.xin@intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
	 <0eed02838e581f2ef2247be8e69bc34cdecce6b2.1285385607.git.xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 27 Sep 2010 14:56:45 +0100
Message-ID: <1285595805.2263.13.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 13:56:48.0850 (UTC) FILETIME=[D45B4320:01CB5E4B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17668.005
X-TM-AS-Result: No--9.948900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in the wrong position in the sequence.  It needs to be
applied after mpassthru.c is created, not before.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

