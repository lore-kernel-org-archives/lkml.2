Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161286Ab2CPVgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:36:22 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:44444 "EHLO
	homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756349Ab2CPVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=cLy92aHa+f1UdCSdoQgT1mWkHpXHzmTKut21btIfKYKNHd7cIwm3ej9Dg7wpE
	4Dct9oRE7QxlLSrkLhgYq5brilyPJeIy5OcB9HTI/qnCdrjLg1s3XBlJM562KnUm
	tnh6V0YRhegp+ZykEw70ldpPIxXil08JM6xyJgRoPXPthw=
Message-ID: <4F63B250.1010200@shealevy.com>
Date: Fri, 16 Mar 2012 17:36:16 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: Re: Proposal: EFI boot stub configuration file
References: <4F63AFD5.3010607@shealevy.com> <4F63B093.9020104@zytor.com>
In-Reply-To: <4F63B093.9020104@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/12 5:28 PM, H. Peter Anvin wrote:
> A file in UCS-2 seems messed up. 

Yeah, it seemed like a good way to let the code be dumb but upon 
reflection it'd just be a confusing inefficiency.

> Otherwise, seems like a reasonable idea, with a major caveat... since 
> the whole point of this is to do something when it isn't possible to 
> set NVRAM variables, it would make most sense to me if the 
> configuration file could be founin a specific location relative to the 
> kernel image itself.

OK. I'll try both approaches to see if the code complexity is greatly 
increased in the relative path case.

Cheers,
Shea
