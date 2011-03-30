Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1C3I3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:29:23 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54172 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1C3I3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:29:21 -0400
Message-ID: <4D92E9DC.3070405@parallels.com>
Date: Wed, 30 Mar 2011 03:29:16 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>
Subject: 2.6.38 containers bug: Infinite loop in /proc/sys/net/ipv6/neigh/neigh/neigh...
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the host context a find on /proc completes, but inside an lxc
container a find on /proc never completes, due to the endless loop in
the title.  (It's not a symlink, it seems to be a cross linked directory.)

This is vanilla 2.6.38, I can attach my .config if you think it'd help.
 (The container's the lxc debian sid template but that's probably not
relevant.)

Rob
