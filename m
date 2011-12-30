Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab1L3QPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 11:15:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:51578 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1L3QPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 11:15:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: zvi dubitzky <dubi@il.ibm.com>
Subject: kvm steal time
Date: Fri, 30 Dec 2011 16:09:32 +0000 (UTC)
Message-ID: <loom.20111230T170447-849@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 87.69.46.193 (Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using k3.2.0-rc1 where the kvm steal time handling is included .
( the .config has :CONFIG_PARAVIRT_GUEST=y, CONFIG_PARAVIRT_TIME_ACCOUNTING=y)
I have a host and 2 guests with that kernel and devised a scenario where 
one guest should have %st > 0 (Linux top utility) .

Still I am always getting $st =0 at the guest top utility 


