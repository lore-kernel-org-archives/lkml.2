Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0JTF7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:59:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40303 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab0JTF7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:59:23 -0400
Message-ID: <4CBE8506.60503@zytor.com>
Date: Tue, 19 Oct 2010 22:58:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Daniel Drake <dsd@laptop.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dilinger@queued.net" <dilinger@queued.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH] OLPC: Add XO-1 suspend/resume support
References: <20101019220159.0DBBE9D401B@zog.reactivated.net> <4CBE1781.1050000@zytor.com> <20101020054752.GA10441@aftab>
In-Reply-To: <20101020054752.GA10441@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 10:47 PM, Borislav Petkov wrote:
> 
> The final version with fixed ACPI sleep is this one:
> http://www.gossamer-threads.com/lists/linux/kernel/1270589
> 
> I ran it for a couple of weeks and it didn't show any regressions. If
> you want to get it into the merge window, I can get you an updated
> version against a -tip branch of your liking ASAP.
> 

If you could prep something against tip:master we *might* be able to get
it in... not sure yet (and it partly depends on when Linus decides to
push the button, of course.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

