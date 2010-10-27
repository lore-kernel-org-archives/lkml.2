Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754Ab0J0JRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:17:42 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:34043 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743Ab0J0JRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:17:40 -0400
Message-ID: <4CC7EDE5.6040009@ge.com>
Date: Wed, 27 Oct 2010 10:16:21 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [PATCH 27/30] staging/vme: rework the bus model
References: <1287729412-24356-1-git-send-email-cota@braap.org> <1287729412-24356-28-git-send-email-cota@braap.org> <20101022232707.GA1370@braap.org> <4CC568F6.2070207@ge.com> <20101026010218.GO10869@flamenco.cs.columbia.edu>
In-Reply-To: <20101026010218.GO10869@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 09:17:38.0792 (UTC) FILETIME=[CCEFBE80:01CB75B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:02, Emilio G. Cota wrote:
> On Mon, Oct 25, 2010 at 12:24:38 +0100, Martyn Welch wrote:
>> On 23/10/10 00:27, Emilio G. Cota wrote:
>>>> * installing drivers even before the bridges they need are present
>>>>   seems counter-intuitive and wrong.
>>
>> There are plenty of instances where a driver can be loaded before the
>> bus is probed or a device is even present. When the bus become
>> available, the probe routine will be run.
> 
> That would be acceptable if and only if no other alternative was available.
> 
> It doesn't make any sense to constrain ourselves to installing
> drivers only BEFORE loading bridge drivers.
> 

I have no idea what your doing, but that simply isn't the case. Your
right - that really would not make any sense, however I'm happily
loading the bridge drivers before any VME device drivers here.

Martyn


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
