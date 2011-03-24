Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1CXP4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:56:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:50568 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab1CXP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:56:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="671159501"
From: Andi Kleen <andi@firstfloor.org>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Ian Lance Taylor <ian@airs.com>, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
References: <1300914043-2297-1-git-send-email-abogani@kernel.org>
	<1300914043-2297-3-git-send-email-abogani@kernel.org>
Date: Thu, 24 Mar 2011 08:54:57 -0700
In-Reply-To: <1300914043-2297-3-git-send-email-abogani@kernel.org> (Alessio
	Igor Bogani's message of "Wed, 23 Mar 2011 22:00:43 +0100")
Message-ID: <m27hbov7hq.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessio Igor Bogani <abogani@kernel.org> writes:

> This work was supported by a hardware donation from the CE Linux Forum.

Patch looks good to me. SORT is a nice trick, too bad it won't 
work for the main kernel.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
