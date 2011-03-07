Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1CGQUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:20:19 -0500
Received: from kroah.org ([198.145.64.141]:45262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab1CGQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:20:15 -0500
Date: Mon, 7 Mar 2011 08:18:05 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: stable@kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [stable] [PATCH] [stable-37] ideapad: read brightness setting
 when have brightness key notify
Message-ID: <20110307161805.GB9088@kroah.com>
References: <1299494125-9655-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299494125-9655-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 06:35:25PM +0800, Ike Panhc wrote:
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922
> 
> On ideapad Y530, the brightness key notify will be blocked if the last notify
> is not responsed by getting the brightness value. Read value when we get the
> notify shall fix the problem and will not have any difference on other ideapads.
> 
> This patch is made against 2.6.37.y and this bug impacts kernel after 2.6.37.
> 
> The equivalent-fix patch is not in upstream yet. Since the policy of stable tree
> is changed and .38 kernel is going to finalize.

What "policy of the stable tree is changed"?  Huh?

> I think to post this patch for stable kernel now should be a good
> idea.

Have you not read the Documentation/stable_kernel_rules.txt and seen
that this is totally and completly not allowed?  Why is it suddenly not
true?

confused,

greg k-h
