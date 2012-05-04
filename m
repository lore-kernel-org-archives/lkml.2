Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2EDNFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:05:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:23206 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2EDNFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137004404"
Message-ID: <4FA3D40F.3040508@intel.com>
Date: Fri, 04 May 2012 21:05:19 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: glommer@redhat.com undelivered email address disturbers
References: <4FA3735F.80107@intel.com> <201205041119.54678.arnd@arndb.de>
In-Reply-To: <201205041119.54678.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 07:19 PM, Arnd Bergmann wrote:

> On Friday 04 May 2012, Alex Shi wrote:
>> This email can not be touched, glommer@redhat.com.
>> but scripts/get_maintainer.pl still give me this.
>>
>> If it is possible to remove it from 2 files in
>> Documentation/virtual/kvm/, or change the get_maintainer.pl to avoid it?
> 
> The output is taken from the git history, which cannot be changed. I don't
> think we want to add a database of people's new email addresses in there.
> 
> 	Arnd


En, if it is possible to maintain a blacknamelist to block untouchable
address from get_maintainer.pl output? That can block many unnecessary
disturbs.
