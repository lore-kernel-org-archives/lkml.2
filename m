Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3ACJfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:35:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab3ACJfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:35:09 -0500
Date: Thu, 3 Jan 2013 10:35:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hsweeten@visionengravers.com
Subject: Re: [PATCH 3/3] HID: Use module_hid_driver macro
In-Reply-To: <201212171528.26445.hartleys@visionengravers.com>
Message-ID: <alpine.LNX.2.00.1301031034500.27348@pobox.suse.cz>
References: <201212171528.26445.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, H Hartley Sweeten wrote:

> Use the new module_hid_driver macro in all HID drivers that have
> a simple register/unregister init/exit.

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs
