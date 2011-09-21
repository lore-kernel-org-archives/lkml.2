Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1IUIKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:10:20 -0400
Received: from lucidpixels.com ([72.73.18.11]:50722 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1IUIKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:10:19 -0400
Date: Wed, 21 Sep 2011 04:10:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 3.1-rc4: IPMI message handler: Event queue full
Message-ID: <alpine.DEB.2.02.1109210409410.31360@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the correct way to fix this aside from disabling IPMI in the 
kernel?

Sep 21 03:02:15 p34 kernel: [29960.523629] IPMI message handler: Event 
queue full, discarding incoming events

Justin.



