Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1FIKk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:40:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45164 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1FIKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:40:26 -0400
Date: Thu, 9 Jun 2011 11:40:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mathias Krause <minipli@googlemail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Message-ID: <20110609104017.GW11521@ZenIV.linux.org.uk>
References: <4DEFD979.50405@tilera.com>
 <1307607243-5737-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307607243-5737-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 10:14:03AM +0200, Mathias Krause wrote:

> v1 was actually the alternative solution in run_init_process()
> v2 was missing the set_fs() calls for SPARC, TILE and Xtensa

sparc does not need it...
