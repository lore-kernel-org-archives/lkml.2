Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3ACJGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:06:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3ACJGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:06:35 -0500
Message-ID: <50E54A14.5010909@suse.cz>
Date: Thu, 03 Jan 2013 10:06:28 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jonathan Kliegman <kliegs@chromium.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] modpost: Add flag -f for making section mismatches fatal
References: <1356029364-11346-1-git-send-email-kliegs@chromium.org> <87ip7f5ecu.fsf@rustcorp.com.au>
In-Reply-To: <87ip7f5ecu.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 3.1.2013 00:56, Rusty Russell napsal(a):
> Jonathan Kliegman <kliegs@chromium.org> writes:
>> The section mismatch warning can be easy to miss during the kernel build
>> process.  Allow it to be marked as fatal to be easily caught and prevent
>> bugs from slipping in.
>>
>> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
> 
> Hmm, a CONFIG option with no Kconfig entry?  That seems weird...

With a Kconfig entry, all{mod,yes}configs would start failing. It can be
enabled with make CONFIG_SECTION_MISMATCH_FATAL=y for now. Maybe it
could be added to Kconfig with 'depends on n', so that it is documented
somewhere.

Michal
