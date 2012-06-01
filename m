Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab2FAIrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:47:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:16772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210Ab2FAIrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106638286"
Message-ID: <4FC881A6.5050505@intel.com>
Date: Fri, 01 Jun 2012 11:47:34 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: dedekind1@gmail.com, linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337771191-95358-1-git-send-email-richard@nod.at>  <1337771191-95358-2-git-send-email-richard@nod.at>  <4FC85780.9070200@intel.com> <4FC8768E.1010703@nod.at> <1338538244.2536.147.camel@sauron.fi.intel.com> <4FC8790D.8070801@nod.at>
In-Reply-To: <4FC8790D.8070801@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/12 11:10, Richard Weinberger wrote:
> Am 01.06.2012 10:10, schrieb Artem Bityutskiy:
>> On Fri, 2012-06-01 at 10:00 +0200, Richard Weinberger wrote:
>>> True. But why is this a problem?
>>> If we can recovers using a full scan after a power cut we are fine.
>>
>> Does fastmap have zero power-cut tolerance by design?
> 
> Yes.
> E.g. If the fastmap was not written corretly the CRC will not match and we fall back
> to scanning. That's why fastmap tries hard to fallback to scanning if anything goes wrong.
> Why should we make fastmap even more complicated than it already is?

That is fine.  It just needs to be documented so people know what to expect.
i.e. fastmap may not be enough for a use case where power cuts are frequent
and/or long scan times are not acceptable.
