Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1BSEKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 23:10:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:56756 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BSEKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 23:10:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: supercilious.dude@gmail.com
Subject: KSM kernel interface
Date: Sat, 19 Feb 2011 04:07:41 +0000
Message-ID: <ijnfme$snp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 5ac0ec50.bb.sky.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a way to enable KSM globally for all eligible pages in the 
system such that applications need not call madvise() themselves? If 
not, is there a way to do so on behalf of a particular application 
without an ugly LD_PRELOAD hack?

Perhaps there is a small kernel modification that might make this 
possible or provide a sysfs flag that enables it (off by default of course)?

I read through the code very briefly, and as far as I can tell, I need 
to add the VM_MERGEABLE flag to all eligible VMAs at the time they are 
created and also __ksm_enter() the associated mm_struct at creation 
also. Would that work?

Thanks

