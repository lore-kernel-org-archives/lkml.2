Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab0D3SnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:43:12 -0400
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:26880 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab0D3RRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:17:18 -0400
Authentication-Results: rtp-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKq62EtAZnwM/2dsb2JhbACdCnGiMpoNhRAEgzs
X-IronPort-AV: E=Sophos;i="4.52,293,1270425600"; 
   d="scan'208";a="106324106"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] firewire: ohci: add MSI support
References: <4BD5667B.1030900@ladisch.de> <4BD5A6C0.3030704@s5r6.in-berlin.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 28 Apr 2010 22:47:22 -0700
In-Reply-To: <4BD5A6C0.3030704@s5r6.in-berlin.de> (Stefan Richter's message of
	"Mon, 26 Apr 2010 16:44:16 +0200")
Message-ID: <adahbmuzu6t.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Does "MSI 00", "MSI: Enable-" mean they do or don't support MSI?  Asks a
 > PCIe newbie.

Yes, the fact that you see an MSI capability structure at all in the
lspci output says that the device supports MSI.  The "Enable-" means
that that MSI has not been enabled.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
