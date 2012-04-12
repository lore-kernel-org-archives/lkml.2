Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643Ab2DLT57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:57:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:56596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2DLT56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="128586029"
Message-ID: <4F8733C5.5080609@linux.intel.com>
Date: Thu, 12 Apr 2012 12:57:57 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>	<1332960678-11879-2-git-send-email-andi@firstfloor.org>	<CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>	<20120412194016.GA30558@merkur.ravnborg.org> <CAMuHMdXfpvprGD18_YYyctfrAk6iRJonWFGFRf9oSaH0u0zfhw@mail.gmail.com>
In-Reply-To: <CAMuHMdXfpvprGD18_YYyctfrAk6iRJonWFGFRf9oSaH0u0zfhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> You should try cc-diasable-warning like this:
>>
>> KBUILD_CFLAGS += $(call cc-disable-warning, ipa-cp-clone)
> That works, thanks!
> Andi, does it still work as expected for you?

No, unfortunately it doesn't enable the flag with my compiler.
Also BTW ipa-cp-clone is not a warning, it's an optimization pass.

Sam any other ideas?

-Andi

