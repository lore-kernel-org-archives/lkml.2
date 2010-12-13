Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0LMKEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:04:40 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:34215 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab0LMKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dJ2bZm5JDh/jdtmbPZv4Fy6w86dbp2u6/oFsRL/TpHR9LVaRAQUQLpig7uGmRn+sdj
         QOpykHp0CnwHmArtEVSmSZAy68cSKBWKw4IPZR6Hv3AiYIVi2xhquS20LNgys70UfT8u
         mpeGRSImonwVsQSfbbOpSWovikcasfCEwAGoI=
Message-ID: <4D05EFB2.3050703@gmail.com>
Date: Mon, 13 Dec 2010 11:04:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <4CFB4C66.1090106@gmail.com> <201012051408.27730.rjw@suse.com>
In-Reply-To: <201012051408.27730.rjw@suse.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 02:08 PM, Rafael J. Wysocki wrote:
> On Sunday, December 05, 2010, Jiri Slaby wrote:
>> On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
>>
>> Hi, this kernel regresses with respect to resume. It doesn't wake up,
>> the screen is black with blinking cursor at position [1, 1].
>> 2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
>> far.
>>
>> I'm using pm-suspend, any ideas what to test before I start to find the
>> reason on my own?
> 
> Please try the pm_test tests for core, processors and devices, eg.:

Hmm, I haven't seen the issues since then. So it had to be some kind of
coincidence -- I see the issue occasionally for some time already. Now
it triggered twice in a row after I updated the kernel.

regards,
-- 
js
