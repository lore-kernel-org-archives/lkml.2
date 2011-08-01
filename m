Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1HAOGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:06:48 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:49042 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1HAOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:06:45 -0400
Message-ID: <4E36B2AA.9060300@ge.com>
Date: Mon, 01 Aug 2011 15:05:30 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] staging: vme: make [alloc|free]_consistent bridge
 specific
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-4-git-send-email-manohar.vanga@cern.ch> <4E36AD01.1050004@ge.com> <20110801140036.GA9670@becoht-mvanga>
In-Reply-To: <20110801140036.GA9670@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2011 14:02:26.0197 (UTC) FILETIME=[A4A95450:01CC5053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 15:00, Manohar Vanga wrote:
> Hi Martyn,
> 
>>> Make PCI dependent functions ([alloc|free]_consistent() in
>>> 'vme.c') bridge specific. By removing the dependency of the
>>> VME bridge framework on PCI, this patch allows for addition of
>>> non-PCI based VME bridges.
>>>
>>
>> I like the approach, I think I agree with Dan, I'd rather see the locking
>> inside the function for now.
> 
> Just noticed that the locking that Dan was referring to and the one you agree
> with in the previous patch ([PATCH 2/8] staging: vme: allow explicit assignment
> of bus numbers) and not this one. Which one are you referring to here?
> 

Whoops. Sorry, Dan's comment about the error printing, not the locking.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
