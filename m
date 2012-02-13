Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2BMOwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:52:55 -0500
Received: from gw.danplanet.com ([50.43.125.66]:57184 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751967Ab2BMOwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:52:54 -0500
From: Dan Smith <danms@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
Date: Mon, 13 Feb 2012 06:52:52 -0800
In-Reply-To: <alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
	(David Rientjes's message of "Mon, 13 Feb 2012 02:12:21 -0800 (PST)")
Message-ID: <87zkcm23az.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DR> It doesn't "ensure" anything without CONFIG_DEBUG_VM enabled, which
DR> isn't the default.

Are you proposing a change in verbiage or a stronger check? A
VM_BUG_ON() seemed on par with other checks, such as the one in
get_user_pages_fast().

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
