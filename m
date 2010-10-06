Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab0JFVoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:44:23 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:57982 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab0JFVoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:44:22 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.57,293,1283731200"; 
   d="scan'208";a="265614603"
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] drivers/infiniband: Remove unnecessary casts of private_data
References: <cover.1283650107.git.joe@perches.com>
	<a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Oct 2010 14:44:17 -0700
In-Reply-To: <a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com>
	(Joe Perches's message of "Sat, 4 Sep 2010 18:52:43 -0700")
Message-ID: <adazkur6lou.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
