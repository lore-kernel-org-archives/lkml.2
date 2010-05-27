Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0E0G6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:58:11 -0400
Received: from mga05.intel.com ([192.55.52.89]:47248 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756390Ab0E0G6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:58:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,310,1272870000"; 
   d="scan'208";a="802305831"
Message-ID: <4BFE17FA.1090103@linux.intel.com>
Date: Thu, 27 May 2010 08:58:02 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
CC: LKLM <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
References: <4BFDDBA9.4010702@np.css.fujitsu.com>
In-Reply-To: <4BFDDBA9.4010702@np.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> And I test this patch on x86_64. It works well.
> 
> Signed-off-by: Jin Dongming<jin.dongming@np.css.fujitsu.com>
> Signed-off-by: Hidetoshi Seto<seto.hidetoshi@jp.fujitsu.com>

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
