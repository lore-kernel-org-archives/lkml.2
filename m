Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab1CDJFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:05:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45251
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759308Ab1CDJF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:05:26 -0500
Date: Fri, 04 Mar 2011 01:06:03 -0800 (PST)
Message-Id: <20110304.010603.104076956.davem@davemloft.net>
To: jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, jirislaby@gmail.com,
        netdev@vger.kernel.org, maxk@qualcomm.com, vtun@office.satix.net
Subject: Re: tun: Failed to create tun sysfs files
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D70A929.4010900@suse.cz>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
	<4D70A929.4010900@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 04 Mar 2011 09:56:09 +0100

> On 03/03/2011 01:52 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
> 
> Hi, I'm seeing this with tun (also with earlier versions):

The name of the attribute was changed to netdev_group in order to
fix this problem, in fact quite some time ago.

See the last entry of the net_class_attributes array in
net/core/net-sysfs.c, if it isn't called "netdev_group"
something is awry.
