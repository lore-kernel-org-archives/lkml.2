Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032066Ab2CSQ0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:26:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60661 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031218Ab2CSQ0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:26:20 -0400
Message-ID: <1332174379.1983.14.camel@joe2Laptop>
Subject: Re: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: David Daney <david.daney@cavium.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Mar 2012 09:26:19 -0700
In-Reply-To: <20120319043937.GN31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
	 <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
	 <4F63646D.1040700@cavium.com> <20120319043937.GN31682@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 00:39 -0400, Ted Ts'o wrote:
> So I've never considered it worthwhile to enable them via a CONFIG_*
> menu item; developers who are debugging a specific problem will
> generally just drop in the specific #define on an ad hoc basis, and
> that works fine.

CONFIG_EXT4_DEBUG_MASK=value and/or a module_param(debug) is
possible to add but as Ted said, it's not really too valuable.

dynamic_debugging the always compiled-in current KERN_DEBUG
or eliminating them altogether might have some value though.

