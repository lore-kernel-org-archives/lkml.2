Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0GLW6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:58:32 -0400
Received: from lucidpixels.com ([75.144.35.66]:40927 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0GLW63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:58:29 -0400
Date: Mon, 12 Jul 2010 18:58:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 2.6.34.1: Marvell 88SE6145 - Only sees one drive?
Message-ID: <alpine.DEB.2.00.1007121857070.6428@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Per the Intel DP55KG manual:

The red eSATA connectors on the back panel can be used to connect an eSATA 
drive.  They can also be used for port replication, which allows the 
aggregation of multiple hard drives on each of the eSATA ports.

Has anyone gotten this working in Linux?

It only sees one of the two drives on one sata port.
Using a thermaltake blackx duet.

Justin.
