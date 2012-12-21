Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab2LUWYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:24:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39292 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab2LUWYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:24:05 -0500
Message-ID: <50D4E15D.70404@zytor.com>
Date: Fri, 21 Dec 2012 14:23:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] stack and heap are executable on x86_64
References: <20121221030018.GA15032@www.outflux.net> <50D3E91C.9060907@zytor.com> <CAE9FiQVNeQqXktmaG0XOJwSxFEVrGKA9j6UDN2N_aDDp-8y_fA@mail.gmail.com> <50D495FD.8060103@zytor.com> <CAE9FiQXcXn0xr_ACt4fS_=xWtXR8zGoYfpSzFKG4nEvKF=sGdQ@mail.gmail.com> <50D49E0A.1080609@zytor.com> <CAE9FiQUu6mvTZ7ONsEeCx8OOocKkCEkC2-OmwdWyjHAJ4=gVHQ@mail.gmail.com> <CAE9FiQWWNhD5ttoiqmHoG0hrYu2NLO1T+DVN7cac2AG4iE+2og@mail.gmail.com>
In-Reply-To: <CAE9FiQWWNhD5ttoiqmHoG0hrYu2NLO1T+DVN7cac2AG4iE+2og@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 02:22 PM, Yinghai Lu wrote:
> 
> please check attached patch that set NX for data/bss/brk with 64bit.
> 

This is on top of for-x86-boot I presume?

	-hpa


