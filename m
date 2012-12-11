Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2LKHHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:07:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2LKHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:07:40 -0500
MIME-Version: 1.0
In-Reply-To: <50C6D3DF.3030209@zytor.com>
References: <1354240068-9821-6-git-send-email-fenghua.yu@intel.com>
	<tip-474355fe313391de2429ae225e0fb02f67ec6c31@git.kernel.org>
	<CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
	<CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
	<50C6D3DF.3030209@zytor.com>
Date: Mon, 10 Dec 2012 23:07:38 -0800
X-Google-Sender-Auth: otFg-H5fnVIZE__1tYhQh09_pCs
Message-ID: <CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
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

On Mon, Dec 10, 2012 at 10:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> That doesn't work if the microcode is replaced at runtime.  However, vmalloc
> doesn't work either since 32 bits needs any one blob to be physically
> contiguous.  I have suggested Fenghua replace it with a linked list of
> kmalloc areas, one for each blob.

you mean:
keep the all of version, and update code need to go over the list to
find latest before apply update?

BTW, do we really need to update microcode so early?

Yinghai
