Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2KLKS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:18:56 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49320 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2KLKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:18:52 -0500
Message-Id: <20121112101440.665694060@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 12 Nov 2012 14:14:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: [patch 0/7] Providing additional information in fdinfo sufficient for c/r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, sorry for sending this series again but I hope this
time to gather the final opinions on the idea in general. I've
rebased the series on top of 3.7-rc5. Take a look please.
Any comments are highly appreciated.

	Cyrill
