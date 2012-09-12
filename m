Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342Ab2ILQQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:16:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab2ILQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:16:14 -0400
Date: Wed, 12 Sep 2012 18:16:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Kbuild: use normal compression settings for tar*-pkg
Message-ID: <20120912161609.GX16230@one.firstfloor.org>
References: <1347133679-14641-1-git-send-email-andi@firstfloor.org> <5050B1CA.7090208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050B1CA.7090208@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe add new default compression options or rename actual ones to -hc-
> (high compression) if users dont like it much?

Doesn't sound useful to me. The normal ones are good enough.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
