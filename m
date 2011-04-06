Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1DFUjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:39:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:37419 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1DFUjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:39:13 -0400
Message-ID: <4D9CCF71.8060906@suse.cz>
Date: Wed, 06 Apr 2011 22:39:13 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/34] kconfig: Do not record timestamp in auto.conf and
 autoconf.h
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>	<1302015561-21047-2-git-send-email-mmarek@suse.cz>	<BANLkTinwKzasKmB_fFzXd+W7F6GGuPO6+g@mail.gmail.com>	<4D9C1842.6000602@suse.cz> <BANLkTi=dCYQcAk8ezF6V_uY7BMEyNAFUTQ@mail.gmail.com>
In-Reply-To: <BANLkTi=dCYQcAk8ezF6V_uY7BMEyNAFUTQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.4.2011 18:25, Arnaud Lacombe wrote:
> Hi,
> 
> On Wed, Apr 6, 2011 at 3:37 AM, Michal Marek <mmarek@suse.cz> wrote:
>> On 5.4.2011 20:57, Arnaud Lacombe wrote:
>>> Hi,
>>>
>>> On Tue, Apr 5, 2011 at 10:58 AM, Michal Marek <mmarek@suse.cz> wrote:
>>>> Timestamps in file data are useless and there is already one in .config
>>>>
>>> hum, shouldn't this be tunable via KCONFIG_NOTIMESTAMP ? This might be
>>> useful to know when the file was generated, independently of the
>>> .config, as conf_write() and conf_write_autoconf() are independent
>>> from one another.
>>
>> Yeah, but ls -l include/generated/autoconf.h will tell you the same,
>> won't it?
>>
> Not if the file is spread to other machine/fs. Not that I care much
> though, but for consistency, either KCONFIG_NOTIMESTAMP is honored in
> every places where timestamps are used, or it should be killed
> altogether.

Or we kill the timestamps in the other places :). auto.conf and
autoconf.h are "internal" files, .config is the file supplied and edited
by the user and I can see that some might find the embedded timestamp
useful. But I doubt that anyone needs the timestamp in auto.conf and
autoconf.h.

Michal
