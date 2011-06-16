Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1FPLkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:40:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1FPLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:40:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
Date: Thu, 16 Jun 2011 13:40:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com> <201106161050.27716.arnd@arndb.de> <20110616085842.GB3215@albatros>
In-Reply-To: <20110616085842.GB3215@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161340.16117.arnd@arndb.de>
X-Provags-ID: V02:K0:k9CbF0WsN+YbK1ZE+eeCvgrJAoBBi/QjApIqo9xJ/4H
 jX4W0ir6iMS9IIwzRPrUzWgfE6MtdvIOXCnSRjQd7ktR/z1vkN
 YlWMbUcfUAHKaQBn6EOzYLX+2cnVJ6aWPfE6UDyOVPDJopCHlL
 H3qkMjP0xAcxechg5zlPlpIPdC8Myvy3d4RI0AAuMBPzCu9F0q
 yoSTvSgusvloaTJlKE91g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011, Vasiliy Kulikov wrote:
> > I have no opinion on whether it's a good idea to include the feature or not.
> 
> Why not?  Have you some specific complains where it can be perhaps too
> strong/insufficient/non-configurable?

No, not at all. I just haven't had the need for this myself, and I'm not
enough of a security person to judge whether the vulnerability addressed
by the patch is a relevant one. E.g. if all the sensitive information
you are hiding in procfs is still available through netlink, your patch
is pointless. Similarly if there is no recorded case of an attack that
relies on any of the information in procfs.

	Arnd
