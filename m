Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2BBTjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:39:54 -0500
Received: from mx2.compro.net ([12.186.155.4]:15741 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab2BBTjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:39:53 -0500
X-IronPort-AV: E=Sophos;i="4.73,347,1325480400"; 
   d="scan'208";a="7582881"
Message-ID: <4F2AE6E9.5090402@compro.net>
Date: Thu, 02 Feb 2012 14:41:29 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: git question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a while but this used to work.

# git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
Cloning into linux-2.6-allstable...
fatal: The remote end hung up unexpectedly

Google showed nothing helpful? Where do I go. I need to bisect from 
2.6.38 to 2.6.39

Thanks
Mark


