Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1G0NyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:54:13 -0400
Received: from lucidpixels.com ([72.73.18.11]:55248 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1G0NyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:54:10 -0400
Date: Wed, 27 Jul 2011 09:54:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Message-ID: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel 2.6.30 on client.
Kernel 2.6.28 on server.

p34 kernel: [92223.918892] NFS: directory motion/cam2 contains a
readdir loop.  Please contact your server vendor.  Offending cookie: 10272

In the past I used NFS to push -> imagery -> NFS server.
Now I've flipped it so I am storing the images locally and viewing them 
remotely, what causes this?

Justin.

