Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab1I3ULx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:11:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37157 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab1I3ULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:11:51 -0400
Subject: Re: [PATCH v4 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
In-Reply-To: <4E85ED25.6060208@shealevy.com>
References: <1316607036-9235-1-git-send-email-matt@console-pimps.org>
	 <1317372688-15150-1-git-send-email-matt@console-pimps.org>
	 <4E85ED25.6060208@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 21:11:48 +0100
Message-ID: <1317413508.3375.40.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 12:24 -0400, Shea Levy wrote:
> Hi Matt,
> 
> I would like to test this patch series (My EFI systems are MBP 5,5, Asus 
> p8p67 pro, and the VirtualBox EFI setup). Will you want to hear the 
> results? If so, is there a specific procedure or set of things to test 
> that you'll want to know about? Also, other than patch 10 should I use 
> the v3 version of the patches sent to this list, or is there a better 
> place to pull the patches from?

Hi Shea,

I'd definitely like to hear the results if you could try it out on your
machines! There's no specific procedure to try, just try to break it ;-)

You can find the patches at the top of the 'x86/efi-stub' branch at,

	https://github.com/mfleming/linux-2.6.git

-- 
Matt Fleming, Intel Open Source Technology Center

