Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1DLDjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:39:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53452 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab1DLDjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:39:43 -0400
Message-ID: <4DA3C96E.7020502@zytor.com>
Date: Mon, 11 Apr 2011 20:39:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-10-git-send-email-mmarek@suse.cz> <4D9B3581.6080105@zytor.com> <4D9C1AA0.9030008@suse.cz> <20110411150820.GA22004@sepie.suse.cz>
In-Reply-To: <20110411150820.GA22004@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 08:08 AM, Michal Marek wrote:
>
> Like this?
>
> Subject: [PATCH] x86: Do not set the rood_dev field in bzImage
>
> This has been obsoleted by the root= commandline for several years.
> People who still depend on this will surely have a copy of the rdev
> command around, the rest of the world gets rid of another piece of
> buildhost-dependent data in the build.
>

Works for me.  "Several years" is even kind of an understatement ;)

	-hpa
