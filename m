Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0FJJQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:16:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0FJJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:15:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
Date: Thu, 10 Jun 2010 11:15:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Albert Cahalan <acahalan@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org, hpa@zytor.com, roland@redhat.com
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com> <AANLkTinFGblE4fW35O0LchJZ22tz_5-qervpGC_lpUj_@mail.gmail.com> <20100609181431.GB1211@us.ibm.com>
In-Reply-To: <20100609181431.GB1211@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101115.51073.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX188lclgrZN/SAhXcRl1uDFkYPRvBXqlZMh9nnX
 AkKAptpbkKAlrAaUjseMPIgOPdTKEZz5wvX7ulwmXNahDXp2PF
 v0P8XXNGiYDDw0pH46pxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 June 2010, Sukadev Bhattiprolu wrote:
> Albert and Randy point out that this would require #ifdefs in the
> application code that intends to be portable across say IA64 and x86.
> 
> Can we instead have all architectures specify [base, size] ?

No objections from me on that.

	Arnd
