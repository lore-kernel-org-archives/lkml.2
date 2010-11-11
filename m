Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0KKVII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:08:08 -0500
Received: from 254.185.140-88.rev.gaoland.net ([88.140.185.254]:44078 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756483Ab0KKVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:08:07 -0500
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 16:08:06 EST
Date: Thu, 11 Nov 2010 21:49:55 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Regression 2.6.36 - driver rtl8169 crashes kernel, triggered by
 user app
Message-ID: <20101111204955.GA8348@electric-eye.fr.zoreil.com>
References: <201011111933.04343@zmi.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011111933.04343@zmi.at>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Monnerie <michael.monnerie@is.it-management.at> :
[...]
> With kernel 2.6.34.7-0.5-desktop, this runs with ~41MiB/s without 
> problems.
> 
> With kernel 2.6.36, it runs at ~26MiB/s, and while doing so, dmesg shows 
> a lot of noise about r8169 complaining:
> http://zmi.at/x/kernel2.6.36-crash86.jpg

Can you test again after reverting 801e147cde02f04b5c2f42764cd43a89fc7400a2 ?

Thanks.

-- 
Ueimor
