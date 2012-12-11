Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2LKQqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:46:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37078 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2LKQqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:46:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121211145716.GB8873@liondog.tnic>
References: <1354240068-9821-6-git-send-email-fenghua.yu@intel.com>
	<tip-474355fe313391de2429ae225e0fb02f67ec6c31@git.kernel.org>
	<CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
	<CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
	<50C6D3DF.3030209@zytor.com>
	<CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com>
	<20121211145716.GB8873@liondog.tnic>
Date: Tue, 11 Dec 2012 08:46:46 -0800
X-Google-Sender-Auth: aXO1yFzjwSVgw83pXikR5hreAfk
Message-ID: <CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 6:57 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Dec 10, 2012 at 11:07:38PM -0800, Yinghai Lu wrote:
>> BTW, do we really need to update microcode so early?
>
> Yes we do. Normally ucode gets applied by the BIOS - this early approach
> is for those cases where OEMs don't release new BIOS anymore but we
> still need to apply a ucode patch as early as possible.

but old bios with old ucode still work with some kind of previous kernel?

Do we have case that system would not work with kernel if ucode is not
updated so early?

Yinghai
