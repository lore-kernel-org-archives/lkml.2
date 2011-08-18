Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1HRIbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:31:53 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:53746 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081Ab1HRIbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:31:49 -0400
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Joe Perches <joe@perches.com>
To: jeffrey.t.kirsher@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
In-Reply-To: <1313655961.2128.107.camel@jtkirshe-mobl>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
	 <1313654829.2128.94.camel@jtkirshe-mobl>
	 <1313655365.32547.68.camel@Joe-Laptop>
	 <1313655961.2128.107.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 01:31:47 -0700
Message-ID: <1313656307.32547.73.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 01:26 -0700, Jeff Kirsher wrote:
> I understand what you saying and asking, my point here is the that the
> "default" style should be understood by checkpatch.pl and not produce
> false warnings.

And I still disagree.

checkpatch should consider whatever
input it gets as if it's a patch.

So, if you really want to feed
git log output as input to checkpatch
you should format that output
appropriately and the best way to do
that is to use git log --format=etc.

Don't suggest removing useful checks.

