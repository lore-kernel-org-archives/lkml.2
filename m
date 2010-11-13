Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0KMMNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 07:13:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36037 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0KMMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 07:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dh71CcL3h1Kcas2W4TrENnBSck84Zr9gECmKxL/KabmiNxCQXIzHdtcbDSn719UvvN
         NkgIWOPSniBTp/px1QKhznJTU5cTUKwl6WnopNT8u3ZkKl+F9REtdyH6pYYQJU/S9ghs
         ODEWPc16bgR+SiryvrcYEtVRmRdL9u+5DMS5A=
Message-ID: <4CDE80E8.6060601@gmail.com>
Date: Sat, 13 Nov 2010 13:13:28 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100903 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, Lionel Debroux <lionel_debroux@yahoo.fr>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [Cocci] Re: status of constification
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com> <Pine.LNX.4.64.1011100727370.352@ask.diku.dk> <4CDC64B9.8070208@gmail.com> <Pine.LNX.4.64.1011112352030.27612@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1011112352030.27612@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> What would the right approach be?  It is not obvious to find 100% of the 
>>> header files, because some of them depend on information in Makefiles.  
>>
>> For 100% coverage you can look at how the Linux Makefiles invoke sparse.
> 
> I haven't looked at it, but I doubt it gives 100% coverage, because one 
> can have code in both the if and else branches of an ifdef.  I would 
> imagine that it gives 100% coverage for whatever architecture you would be 
> compiling for?

For my purposes it's enough to find all includes for a given .config.

What would be also useful is if Coccinelle could somehow ignore ifdef's that
guard code blocks so that it would analyse all code in a translation unit. 

Thanks Emese

