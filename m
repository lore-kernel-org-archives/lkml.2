Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1BWPTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:19:23 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:58969 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1BWPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:19:22 -0500
Message-ID: <4D652574.8040206@ge.com>
Date: Wed, 23 Feb 2011 15:19:16 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: vme: remove unreachable code
References: <1298403376-28352-1-git-send-email-manohar.vanga@cern.ch> <1298403376-28352-2-git-send-email-manohar.vanga@cern.ch> <4D64D10A.3070702@ge.com> <20110223121726.GR1898@bicker> <4D652344.1020402@ge.com> <20110223151618.GA27806@becoht-mvanga>
In-Reply-To: <20110223151618.GA27806@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 15:19:14.0545 (UTC) FILETIME=[07C52E10:01CBD36D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/11 15:16, Manohar Vanga wrote:
>>> There are two problems with this loop.  1) It unregisters the device
>>> which failed to register.  2) It is a forever loop.
>>>
>>
>> Even if "i" is a signed int?
> 
> The infinite loop is because "i" is not decremented anywhere in the loop. Not
> because of signedness.
> 

Ah, yeah, that would help.

Martyn

> Thanks,
> Manohar Vanga


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
