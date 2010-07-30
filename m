Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750836Ab0G3EFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:05:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56411 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0G3EFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vM0Qkp/o/zgX0O7bOiLy7JON0XKh5iBx8ekRS4x4s5dDBj1Jaef7PKdeTSQSIVJNgF
         vtUdgyUI+4m+H96C/mCmSc/K4V+P/TUIS0zztvSh2uVbK8+2tmRituw7LjeseqwcoVA1
         C/L31o1eb2m4tn56eI0HLeurf46vjroS+XUJw=
Message-ID: <4C524F7A.20505@gmail.com>
Date: Thu, 29 Jul 2010 21:05:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: PSA: Please update your flash plugin!
References: <E1OefgE-0005vu-JN@tytso-glaptop>
In-Reply-To: <E1OefgE-0005vu-JN@tytso-glaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 07:50 PM, Theodore Ts'o wrote:
> This is a public service announcement --- if you are running Flash 10.0,
> make sure you upgrade to 10.1.  Flash 10.0 has a horrible security
> vulnerability:
>
> 	http://www.adobe.com/support/security/bulletins/apsb10-14.html
>
> I have Google Analytics running on the ksummit2010 website, and in
> addition to discovering that 59% used Firefox and 25% were using Chrome,
> and that the most popular screen resolution was 1280x800 followed by
> 1280x1024, etc. --- I also was able to find that while 59% were running
> Flash 10.1, over 40% of the visitors to the ksummit2010 web site were
> running a vulnerable version of Adobe flash, which has a remote code
> execution vulerability.
>
> If you were visiting that site from your development system, which you
> use to push changes to a subsystem maintianer, or even Linus, hopefully
> I don't need to tell you what a bad idea it is to leave yourself open
> and vulnerable like this.  (This particular security problem with Flash
> has been announced for almost 2 months at this point!)
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


biggest problem here is they havn't updated their x86_64(pure64) version 
yet. hopefully hey release an update soon.

Justin P. Mattock
