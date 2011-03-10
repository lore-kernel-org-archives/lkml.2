Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1CJUlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:41:21 -0500
Received: from mx2.compro.net ([12.186.155.4]:3321 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab1CJUlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:41:20 -0500
X-Greylist: delayed 858 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 15:41:20 EST
X-IronPort-AV: E=Sophos;i="4.62,297,1297054800"; 
   d="scan'208";a="6392735"
Message-ID: <4D793414.4090206@compro.net>
Date: Thu, 10 Mar 2011 15:27:00 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: kernel git bisect question
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between git bisect [good | bad ]s should I always "make clean" or can I
count on the build system to take care of everything properly?

Thanks
Mark

