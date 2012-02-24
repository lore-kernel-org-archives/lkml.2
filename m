Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2BXVDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:03:16 -0500
Received: from gw.danplanet.com ([50.43.125.66]:45858 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932173Ab2BXVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:03:15 -0500
From: Dan Smith <danms@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
	<87zkcm23az.fsf@caffeine.danplanet.com>
	<alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
	<87obsoxcn6.fsf@danplanet.com>
	<20120224125519.89120828.akpm@linux-foundation.org>
Date: Fri, 24 Feb 2012 13:03:11 -0800
In-Reply-To: <20120224125519.89120828.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 24 Feb 2012 12:55:19 -0800")
Message-ID: <87k43cx7u8.fsf@danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM> Well...  why should we apply the patch?  Is there some buggy code
AM> which is triggering the problem?  Do you intend to write some buggy
AM> code to trigger the problem?  ;)

Well, I already did and it took me longer to figure out than it should
have :)

AM> Also, as it's a developer-only thing we should arrange for the
AM> overhead to vanish when CONFIG_DEBUG_VM=n?

Heh, if you like that flavor, see the previous version of the patch at
the top of this thread :)

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
