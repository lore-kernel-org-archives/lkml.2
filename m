Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0LWNVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:21:38 -0500
Received: from www17.your-server.de ([213.133.104.17]:52341 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0LWNVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:21:36 -0500
References: <1293020757.1998.2.camel@localhost.localdomain> <AANLkTin6GMiXHuoVzNWPcj0jXDqWyfWCwW9fd-v=pq=X@mail.gmail.com> <20101222190621.GA16046@balbir.in.ibm.com>
In-Reply-To: <20101222190621.GA16046@balbir.in.ibm.com>
Mime-Version: 1.0 (iPod Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <EF4E1E75-4D88-4D65-9ACB-69390FDF4C18@m3y3r.de>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: iPod Mail (8C148)
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.37-rc7: NULL pointer dereference
Date: Thu, 23 Dec 2010 14:21:27 +0100
To: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.12.2010 um 20:06 schrieb Balbir Singh <balbir@linux.vnet.ibm.com>:

> Thanks for the report, does this happen at bootup?

I tried to manually upgrade systemd-10 on Fedora 14 to systemd-15. The above error occured after the installation, while trying to reboot the computer. Sadly I needed to revert to systemd-10 because of SELinux policy problems.

With kind regards
Thomas