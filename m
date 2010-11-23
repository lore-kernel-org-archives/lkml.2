Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0KWPYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:24:44 -0500
Received: from mail.perches.com ([173.55.12.10]:1804 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab0KWPYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:24:43 -0500
Subject: Re: [PATCH] hid: hidpidff: Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011231336420.18801@pobox.suse.cz>
References: <1290497701.28824.6.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1011231336420.18801@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 07:24:40 -0800
Message-ID: <1290525880.28824.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 13:36 +0100, Jiri Kosina wrote:
> On Mon, 22 Nov 2010, Joe Perches wrote:
> > Prefixes were not standardized in this module.
> > Some used "hid-pidff:", others "hidpidff:".
> > Add pr_fmt(fmt) KBUILD_MODNAME ": " fmt to standardize prefix uses.
> Hmm, how about using dev_dbg instead? So that we get the bonus of having 
> the device name there for free?

Too much restructuring required.
There's no device available in many of the pr_debug uses.


