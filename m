Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1AFXfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:35:16 -0500
Received: from antcom.de ([188.40.178.216]:49200 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab1AFXfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:35:13 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 18:35:13 EST
Message-ID: <4D265022.5020700@antcom.de>
Date: Fri, 07 Jan 2011 00:28:34 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20101211 Icedove/3.0.11
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel build ignores missing mkimage on building uImage
References: <4D0B8D85.5090605@antcom.de> <20110106135558.GC1841@sepie.suse.cz>
In-Reply-To: <20110106135558.GC1841@sepie.suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/01/11 14:55, Michal Marek wrote:
>> I.e. it says: "uImage is ready" even though the uImage file doesn't
>> exist because mkimage is missing.
>>
>> (I'm working with Linux' current mainline GIT and also see that the
>> problem is also present in the mmarek repo on git.kernel.org.)
>>
>> I propose the attached patch.
>>
>> Thanks for considering.
> 
> The patch makes sense and afaics none of the architectures relies on
> this behaviour (either they can't work without mkimage, or a
> uimage-style target has to be requested by the user). Can I assume
> "Signed-off-by: Roland Stigge <stigge@antcom.de>" on this patch.

Yes!

Thanks,

Roland
