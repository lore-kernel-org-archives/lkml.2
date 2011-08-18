Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1HRI4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:56:07 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:41781 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755237Ab1HRI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:56:05 -0400
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Joe Perches <joe@perches.com>
To: jeffrey.t.kirsher@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
In-Reply-To: <1313657022.2128.116.camel@jtkirshe-mobl>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
	 <1313654829.2128.94.camel@jtkirshe-mobl>
	 <1313655365.32547.68.camel@Joe-Laptop>
	 <1313655961.2128.107.camel@jtkirshe-mobl>
	 <1313656307.32547.73.camel@Joe-Laptop>
	 <1313657022.2128.116.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 01:56:02 -0700
Message-ID: <1313657762.32547.80.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 01:43 -0700, Jeff Kirsher wrote:
> I understand what your saying, and I think that your suggestion about
> possibly implementing a "--input=git" option to checkpatch.pl might be a
> happy middle ground to resolve the numerous false warnings this check
> produces.

As far as I can tell, --ignore= suffices.

If you really want to use checkpatch for checking
already committed patches, maybe you should not
use git log but use git format-patch instead.

$ git format-patch -1 --stdout | ./scripts/checkpatch.pl -

That works without any problems.

