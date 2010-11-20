Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0KTApc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:45:32 -0500
Received: from 65.112.116-78.rev.gaoland.net ([78.116.112.65]:37749 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752592Ab0KTApb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:45:31 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 19:45:30 EST
Date: Sat, 20 Nov 2010 01:35:31 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Regression 2.6.36 - driver rtl8169 crashes kernel, triggered by
 user app
Message-ID: <20101120003531.GA15167@electric-eye.fr.zoreil.com>
References: <201011181549.08545@zmi.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011181549.08545@zmi.at>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Monnerie <michael.monnerie@is.it-management.at> :
> I did not get any answer, so here again:

I already answered one week ago, you were Cc:ed and I had my
answer delivered through vger. Please check your spambox.

Can you test again after reverting 801e147cde02f04b5c2f42764cd43a89fc7400a2 ?

-- 
Ueimor
