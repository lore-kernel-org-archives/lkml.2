Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab1D2RoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:44:03 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42574 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678Ab1D2RoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:44:00 -0400
Date: Fri, 29 Apr 2011 19:43:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Valdis.Kletnieks@vt.edu, bp@alien8.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
Message-ID: <20110429174358.GA12176@merkur.ravnborg.org>
References: <71633.1304013549@localhost> <1304083893-18849-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304083893-18849-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 03:31:33PM +0200, Michal Marek wrote:
> Add support for make W=12, make W=123 and so on, to enable warnings from
> multiple W= levels. Normally, make W=<level> does not include warnings
> from the previous level.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

I was considering W=all - but that gives less flexibility, which is
what has been requested.

	Sam
