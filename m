Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2LNPKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:10:31 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:37950 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2LNPKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:10:30 -0500
X-Greylist: delayed 693 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2012 10:10:29 EST
Message-ID: <50CB3EAB.309@itwm.fraunhofer.de>
Date: Fri, 14 Dec 2012 15:58:51 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7 ends in APIC panic
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 01:16 PM, Bernd Schubert wrote:
> Hello,
>
> I just tried to boot 3.7 and it ends in an APIC panic. I tried to use
> the recommended "apic=debug", but that does not change anything in the
> output, at least not in the visible part. The last known kernel to boot
> was 3.5. If it matters I can try to boot 3.6.

So linux-3.6 also boots. Any idea what is going on or do I really need 
to bisect?


Thanks,
Bernd



