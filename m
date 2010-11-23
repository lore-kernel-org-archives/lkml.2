Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0KWMgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:36:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:51181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab0KWMgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:36:51 -0500
Date: Tue, 23 Nov 2010 13:36:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: hidpidff: Use pr_<level>
In-Reply-To: <1290497701.28824.6.camel@Joe-Laptop>
Message-ID: <alpine.LNX.2.00.1011231336420.18801@pobox.suse.cz>
References: <1290497701.28824.6.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010, Joe Perches wrote:

> Prefixes were not standardized in this module.
> Some used "hid-pidff:", others "hidpidff:".
> Add pr_fmt(fmt) KBUILD_MODNAME ": " fmt to standardize prefix uses.

Hmm, how about using dev_dbg instead? So that we get the bonus of having 
the device name there for free?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
