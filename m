Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2IKDBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:01:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2IKDBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:01:15 -0400
Date: Tue, 11 Sep 2012 05:01:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Kbuild: use normal compression settings for tar*-pkg
Message-ID: <20120911030109.GU16230@one.firstfloor.org>
References: <1347133679-14641-1-git-send-email-andi@firstfloor.org> <20120911004633.GA21147@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911004633.GA21147@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> -c should be kept because it means --stdout and --keep

It seems to work without it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
