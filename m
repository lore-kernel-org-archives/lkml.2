Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab1JLTIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:08:49 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47533 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab1JLTIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:08:48 -0400
Date: Wed, 12 Oct 2011 12:08:44 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Muraliraja Muniraju <muralira@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] net-netlink: Add a new attribute to expose TOS
 values via netlink
Message-ID: <20111012120844.64568ff2@nehalam.linuxnetplumber.net>
In-Reply-To: <1318446035-10267-1-git-send-email-muralira@google.com>
References: <20111012085235.3b78729b@nehalam.linuxnetplumber.net>
	<1318446035-10267-1-git-send-email-muralira@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 12:00:35 -0700
Muraliraja Muniraju <muralira@google.com> wrote:

> From: Murali Raja <muralira@google.com>
> 
> This patch exposes the tos value for the TCP sockets when the TOS flag
> is requested in the ext_flags for the inet_diag request. This would mainly be
> used to expose TOS values for both for TCP and UDP sockets. Currently it is
> supported for TCP. When netlink support for UDP would be added the support
> to expose the TOS values would alse be done. For IPV4 tos value is exposed
> and for IPV6 tclass value is exposed.
> 
> Signed-off-by: Murali Raja <muralira@google.com>
> ---
> Changelog since v3:
> - Removed the tos structure from the inet_diag.h
> 
> Changelog since v2:
> - Added support for IPv6 and used better API.
> 
> Changelog since v3:
> - Removed reserved fields.


After this is accepted; it is trivial to add support to ss command.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>
