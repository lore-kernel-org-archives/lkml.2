Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1LKSaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:30:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:50961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1LKSaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:30:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101022365"
Subject: Re: iwlagn regression in v3.1.5
From: wwguy <wey-yi.w.guy@intel.com>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: Udo Steinberg <udo@hypervisor.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4EE4E152.2070204@udo.edu>
References: <4EE4AEF4.2080702@udo.edu> <4EE4DB55.4090804@udo.edu>
	 <20111211174138.79e51fe8@x220.fritz.box>  <4EE4E152.2070204@udo.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Dec 2011 10:23:35 -0800
Message-ID: <1323627815.1806.19.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 08:58 -0800, Andrej Gelenberg wrote:
> Hi,
> 
> this is pretty mean regression for the stable kernel. You may the fix 
> only for cards, which need it and not for all of them.

Could you elaborate more on the failure case and setup. this patch is to
address HT40 related problem which cause the iwlwifi firmware crash.

Thanks
Wey
> >


