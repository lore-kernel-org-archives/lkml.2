Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0CXREf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:04:35 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:53093 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0CXREe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JN9u5b+O1S5ay4qTH1mHkEuFPsyizE9TM2jstyuJK8kJH4snO3CEzXBVfpHRfRf3KU
         TDHiviubDydqtNywBXcMhPeY4d27W1RWnY7QDcYxO9LQU7Of7AxDanNbCUt2Ir8PcZmA
         R3ACuWqTeFMIa5ZgiciH5OytvYfRe+t+St6Hc=
Message-ID: <4BAA461E.7090907@gmail.com>
Date: Wed, 24 Mar 2010 18:04:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2010 08:20 PM, Linus Torvalds wrote:
> I'd also like to hear more about actual uses. Does _any_ other Unix-like 
> system actually implement this writable limits thing?

I'm currently not aware of any. Will do some research if that matters.

> Who is asking for  it? 

The scenario I described in the pull request is true, SAP requested that.

thanks,
-- 
js
