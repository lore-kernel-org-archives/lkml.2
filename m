Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0IPOFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:05:05 -0400
Received: from tex.lwn.net ([70.33.254.29]:54329 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0IPOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:05:04 -0400
Date: Thu, 16 Sep 2010 08:04:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] viafb security fix
Message-ID: <20100916080456.0f50ec6a@bike.lwn.net>
In-Reply-To: <4C9162BA.6000307@gmx.de>
References: <4C9162BA.6000307@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 02:20:10 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> It contains a single patch to initialize the memory before it is copied to 
> userspace. As this issue could be a security flaw it would be good to have this 
> patch in the next release.

This one seems worth directing toward the stable tree as well.

jon
