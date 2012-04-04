Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab2DDTmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:42:16 -0400
Received: from ka.mail.enyo.de ([87.106.162.201]:47423 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab2DDTmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:42:15 -0400
X-Greylist: delayed 1513 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2012 15:42:15 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: Martin Lucina <martin@lucina.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Implement IP_EVIL socket option (RFC 3514)
References: <1333284791-5363-1-git-send-email-martin@lucina.net>
Date: Wed, 04 Apr 2012 21:17:00 +0200
In-Reply-To: <1333284791-5363-1-git-send-email-martin@lucina.net> (Martin
	Lucina's message of "Sun, 1 Apr 2012 14:53:11 +0200")
Message-ID: <87r4w3nw7n.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Lucina:

> This patch implements the IP_EVIL socket option, allowing user-space
> applications to set the Security Flag in the IPv4 Header, aka "evil" bit,
> as defined in RFC 3514.

I need this to fix a security issue.  Could this be merged for real,
please?
