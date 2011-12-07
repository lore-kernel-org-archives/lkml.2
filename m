Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1LGTZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:25:14 -0500
Received: from lo.gmane.org ([80.91.229.12]:57118 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab1LGTZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:25:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH] Add refcount type and refcount misuse debugging
Date: Wed, 7 Dec 2011 19:22:11 +0000 (UTC)
Message-ID: <loom.20111207T190350-580@post.gmane.org>
References: <20111206230107.GA22471@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 173.164.30.65 (Mozilla/5.0 (X11; CrOS i686 1193.65.0) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.44 Safari/535.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan <at> gmail.com> writes:

[snip]

> Enter _refcnt_t (non-atomic version), refcnt_t (atomic version) datatypes
> and CONFIG_DEBUG_REFCNT config option.

Is kref_t not appropriate to fill this niche?

cheers!
will

