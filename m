Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2GXQ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:29:40 -0400
Received: from mail.vyatta.com ([76.74.103.46]:51295 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab2GXQ3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:29:38 -0400
Date: Tue, 24 Jul 2012 09:29:14 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org,
        ben@decadent.org.uk
Subject: Re: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
Message-ID: <20120724092914.60f3d90a@nehalam.linuxnetplumber.net>
In-Reply-To: <1343145701-3691-10-git-send-email-kys@microsoft.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
	<1343145701-3691-1-git-send-email-kys@microsoft.com>
	<1343145701-3691-10-git-send-email-kys@microsoft.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2012 09:01:34 -0700
"K. Y. Srinivasan" <kys@microsoft.com> wrote:

> +	memset(cmd, 0, sizeof(cmd));
> +	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
> +	strcat(cmd, if_name);
> +	strcat(cmd, " | awk '/default/ {print $3 }'");


Much simpler method:

ip route show match 0/0

