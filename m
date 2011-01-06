Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1AFRC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:02:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53717 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1AFRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i9yTqUA0drrvP2YiTR5+KtKb+kXcEfqQIfWwebYHKt7HrgQfhjzfYY9i4eAniWge/L
         JKkreYnf1f0VQVdU6RWSHeUKA8r0HOJ/8Z4OJ4Ljc9n3Bj/OgN7kzfbu0rqEmW1+upKZ
         M1u7d/nq/Sta18FyIvmfaeOlTtWBvAUZra75k=
Message-ID: <4D25F4CF.1030009@gmail.com>
Date: Thu, 06 Jan 2011 17:58:55 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
References: <4D25AEEE.1050401@gmail.com> <1294322613.2016.333.camel@laptop> <4D25ED22.3070900@gmail.com>
In-Reply-To: <4D25ED22.3070900@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/01/2011 17:26, Marco Stornelli ha scritto:
> Il 06/01/2011 15:03, Peter Zijlstra ha scritto:
> and temporary information with a complete fs structure. However we are
> 

Errata corrige: maybe I used the wrong term, I meant "volatile" instead
of "temporary" information, i.e. I'd like to save this info to re-read
it later but I don't want to store it in flash, a simple log, run-time
information for debug like a flight-recorder or whatever you want.
