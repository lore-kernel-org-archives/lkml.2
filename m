Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0IJPxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:53:36 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:46528 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab0IJPxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:53:35 -0400
X-AuditID: 12074422-b7bbfae000005e9b-e8-4c8a54731733
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <201009101549.03845.Martin@lichtvoll.de>
Date: Fri, 10 Sep 2010 11:53:29 -0400
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Paolo Ornati <ornati@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <412F0940-B810-4F19-8064-CD3E11DEE8B4@mit.edu>
References: <201008312153.45792.Martin@lichtvoll.de> <201009091618.51064.Martin@lichtvoll.de> <20100910135511.53c0089a@schatten.dmk.lab> (sfid-20100910_151146_255717_5F7DBF5E) <201009101549.03845.Martin@lichtvoll.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10, 2010, at 9:49 AM, Martin Steigerwald wrote:

> Maybe next time: "Fails to boot with partially shown backtrace, with some 
> ext4 / readahead function calls inside it"? Or even more general some I/O 
> / filesystem related functions?

Learn how to use a serial console so you can get a full backtrace, thus saving yourself and folks interesting in helping you valuable time?  :-)

-- Ted

