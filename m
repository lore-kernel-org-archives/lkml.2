Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2LTSO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:14:57 -0500
Received: from plane.gmane.org ([80.91.229.3]:58256 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2LTSOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:14:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Widawsky <ben@bwidawsk.net>
Subject: Re: [PATCH 00/13] Add gdb python scripts as kernel debugging helpers
Date: Thu, 20 Dec 2012 17:59:15 +0000 (UTC)
Message-ID: <loom.20121220T185741-139@post.gmane.org>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 134.134.137.71 (Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka <jan.kiszka <at> siemens.com> writes:

> 
> Version 2 of this series is a rebase over 3.7-rc4 to resolve some minor
> collision in the top-level makefile. Moreover, this implements automatic
> symbol loading for kernel modules using silent breakpoints. See patch 3
> for details.
> 
> Unless someone complains over this series or suggests a better workflow,
> I'm planning to send a pull to Linus during the next merge window.
> 

I've been using lx-symbols for the last few days, and am pretty happy with it.
Thanks for your work Jan.

Acked-by: Ben Widawsky <ben@bwidawsk.net>

