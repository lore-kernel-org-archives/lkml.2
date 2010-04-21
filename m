Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0DUPrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:47:15 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54161 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab0DUPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oMizNrjm+UYidx2YtPV8mxkK3egMgKen1SYwQjjbkzGVCAqRycsZcex26cZGEauLjq
         dcwLNYqXw35yxI0SfCMDxOi/kNF3Em/d5/jwyEbUdeu3Ragh67v80HrdrlnBM2Ah/Wv3
         drE/9Ptp/Gu2bbp+rSGg8CEHuVPZvADC0zmIM=
Message-ID: <4BCF1DFB.8020202@gmail.com>
Date: Wed, 21 Apr 2010 17:47:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.5 Thunderbird/3.1b1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       adilger@sun.com, linux-ext4@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       mszeredi@suse.cz
Subject: Re: busy inodes -> ext3 umount crash
References: <4BC8A7C1.20102@gmail.com> <20100419141158.GB5439@quack.suse.cz>	 <4BCC69B4.2050308@gmail.com> <4BCDB633.9040901@gmail.com>	 <20100420152844.GB3885@quack.suse.cz>  <4BCF16CE.2080403@gmail.com> <1271863450.2899.12.camel@dhcp235-240.rdu.redhat.com>
In-Reply-To: <1271863450.2899.12.camel@dhcp235-240.rdu.redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 05:24 PM, Eric Paris wrote:
> I'll take a look, but I'm not seeing a problem right off
> hand.  This patch wasn't supposed to mess with inode refcounting at
> all....

Heh, but with very high probability now, it did :). Do you want me to
inject some printouts anywhere? Can you reproduce it? KDE doesn't
trigger the bug. After I switched from KDE to gnome in qemu, it started
to occur (X :0 & (sleep 1; DISPLAY=:0 gnome-session)).

-- 
js
