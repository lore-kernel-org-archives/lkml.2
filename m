Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0LTOBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:01:44 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:42115 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757582Ab0LTOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:01:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAB/xDk1FpYat/2dsb2JhbACDY5Iojhd0rUA8hlwuiFyBIYM1dASEZYYch3Y
X-IronPort-AV: E=Sophos;i="4.60,202,1291611600"; 
   d="scan'208";a="85931126"
Message-ID: <4D0F61EA.1010905@gmail.com>
Date: Mon, 20 Dec 2010 09:02:18 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101028 Iceape/2.0.10
MIME-Version: 1.0
To: maciej.rutecki@gmail.com
CC: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        keithp@keithp.com, ak@linux.intel.com, chris@chris-wilson.co.uk,
        gregkh@suse.de, stable@kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com> <201012192142.11656.maciej.rutecki@gmail.com>
In-Reply-To: <201012192142.11656.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=25242
> for your bug report, please add your address to the CC list in there, thanks!
>    
>
Reverting the commit 541cc966915b6756e54c20eebe60ae957afdb537 fixes the 
problem on my G33 system

Woody

