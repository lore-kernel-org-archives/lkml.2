Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0E0Orw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:47:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42141 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab0E0Orv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:47:51 -0400
Message-ID: <4BFE86D4.60602@nokia.com>
Date: Thu, 27 May 2010 17:51:00 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Arjan van de Ven <arjan@infradead.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Brown <len.brown@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Len@smtp1.linux-foundation.org" <Len@smtp1.linux-foundation.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle driver
 for select intel processors
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>	<e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>	<198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>	<87ljb5l9d5.fsf@deeprootsystems.com> <20100527072207.2e783b1e@infradead.org>
In-Reply-To: <20100527072207.2e783b1e@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 14:28:00.0061 (UTC) FILETIME=[CEE026D0:01CAFDA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


ext Arjan van de Ven wrote:

> it's really inconvenient to have such drivers hidden in the
> architecture code; it's much more convenient for cpuidle developers
> if they're all in one place.
>   

why?

> Think of it this way: you're not putting the NIC driver for your SOC in
> a architecture directory either...
>
>   

That would be a separate chip, usually, which has its own driver.

The SOC has some bus interface and the arch-specific part of it, if any, 
is in the arch directory.

igor

