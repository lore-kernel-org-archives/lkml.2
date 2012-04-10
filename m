Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab2DJTLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:11:18 -0400
Received: from edge10.ethz.ch ([82.130.75.186]:42863 "EHLO edge10.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2DJTLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:11:16 -0400
From: Thomas Rast <trast@student.ethz.ch>
To: Jakub Narebski <jnareb@gmail.com>
CC: Junio C Hamano <gitster@pobox.com>, <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.10
References: <7v1uo01ta1.fsf@alter.siamese.dyndns.org>
	<m3398bbf7y.fsf@localhost.localdomain>
Date: Tue, 10 Apr 2012 21:11:12 +0200
In-Reply-To: <m3398bbf7y.fsf@localhost.localdomain> (Jakub Narebski's message
	of "Tue, 10 Apr 2012 11:43:46 -0700 (PDT)")
Message-ID: <878vi3mmgf.fsf@thomas.inf.ethz.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [188.155.176.28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Narebski <jnareb@gmail.com> writes:

> Junio C Hamano <gitster@pobox.com> writes:
>
>> Git v1.7.10 Release Notes
>> =========================
>> 
>> Compatibility Notes
>> -------------------
> [...]
>>  * The "--binary/-b" options to "git am" have been a no-op for quite a
>>    while and were deprecated in mid 2008 (v1.6.0).  When you give these
>>    options to "git am", it will now warn and ask you not to use them.
> [...]
>> Updates since v1.7.9
>> --------------------
> [...]
>>  * "git am" learned to pass "-b" option to underlying "git mailinfo", so
>>    that a bracketed string other than "PATCH" at the beginning can be kept.
>
> So how it is in 1.7.10?  Is "git am -b ..." a no-op, now showing
> deprecation notice, or does it pass "-b" to "git mailinfo" to limit
> stripping of bracketed strings to those containing the word "PATCH"?

The option to pass down -b from git-am is called --keep-non-patch.  The
deprecation of -b is meant to let us call it -b for convenience in a
later release.

-- 
Thomas Rast
trast@{inf,student}.ethz.ch
