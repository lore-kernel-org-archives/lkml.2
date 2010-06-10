Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab0FJMiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:38:22 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57186 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0FJMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:38:20 -0400
Message-ID: <4C10DCB7.7090903@in.ibm.com>
Date: Thu, 10 Jun 2010 18:08:15 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: next June 10: S390 build failure [arch/s390/kvm/kvm.ko]
References: <20100610160012.30ea7606.sfr@canb.auug.org.au>
In-Reply-To: <20100610160012.30ea7606.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next fails to build on a s390 box with

ERROR: "__kvm_s390_vcpu_store_status" [arch/s390/kvm/kvm.ko] undefined!

Yesterday's next was good.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

