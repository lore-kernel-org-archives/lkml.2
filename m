Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0DANvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:51:12 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:46403 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0DANvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:51:01 -0400
Message-ID: <4BB4A4C2.4090901@grupopie.com>
Date: Thu, 01 Apr 2010 14:50:58 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Performance disparity, problem found
References: <4BB483E1.9050203@grupopie.com> <201004011430.56503.elendil@planet.nl>
In-Reply-To: <201004011430.56503.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Paulo Marques wrote:
>> Now the problem is that /proc/cpuinfo is read only. Would it be possible
>> to make /proc/cpuinfo writable so that I could do:
>>
>> echo -n "model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @
>> 2.40GHz" > /proc/cpuinfo
>>
>> in the first machine and get a performance similar to the second machine?
> 
> Good catch! 'chmod +w /proc/cpuinfo' should do the trick.
> 
> Cheers,
> FJP

Thanks, that did the trick. My first machine is much faster now and it
even has 4 cores! :)

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
