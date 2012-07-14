Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2GNVsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 17:48:24 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38537 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2GNVsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 17:48:19 -0400
Date: Sat, 14 Jul 2012 14:48:00 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Piotr Sawuk" <a9702387@unet.univie.ac.at>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resurrecting tcphealth
Message-ID: <20120714144800.7f8c97f6@nehalam.linuxnetplumber.net>
In-Reply-To: <dee325378a2d3b7792da9640fc14905f.squirrel@webmail.univie.ac.at>
References: <dee325378a2d3b7792da9640fc14905f.squirrel@webmail.univie.ac.at>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe it would be better to use netlink info (for ss command)
rather than a /proc/net interface.
See how existing TCP values and MEMINFO are handled.
