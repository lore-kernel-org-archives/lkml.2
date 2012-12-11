Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2LKRA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:00:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57027 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2LKRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <50C763C2.5020603@zytor.com>
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
	<CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
	<50C763C2.5020603@zytor.com>
Date: Tue, 11 Dec 2012 09:00:55 -0800
X-Google-Sender-Auth: 5hlA2bBB970PwNGFvWwog1RdoGs
Message-ID: <CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
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

On Tue, Dec 11, 2012 at 8:48 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> It's not about "not working"... it is about "if the microcode isn't
> loaded early we have to disable features."

ok, then next question is how early it should be.

before early_cpu_init/early_identify_cpu

or just before check_bugs/identify_cpu

Yinghai
