Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2GBHV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:21:29 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:51456 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GBHV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:21:28 -0400
Message-ID: <4FF14BF4.5070007@bootc.net>
Date: Mon, 02 Jul 2012 08:21:24 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120619 Thunderbird/14.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [ 15/48] e1000e: Remove special case for 82573/82574 ASPM  L1
 disablement
References: <20120701172006.535271340@decadent.org.uk> <20120701172008.810233261@decadent.org.uk> <20120701225950.GD3728@burratino>
In-Reply-To: <20120701225950.GD3728@burratino>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2012 23:59, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Chris Boot <bootc@bootc.net>
>>
>> commit 59aed95263bdd0e2b48eb9be5a94346d2d4abf90 upstream.
> This patch still seems both lovely and unnecessary, and I would prefer
> that it not be part of 3.2-stable.  If I understood the replies before,
> it is safe to drop it, right?

My only comment about this would be that I haven't tested it without
both patches, although I can't see why there would necessarily be a
problem with only having one patch and not the other.

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net

