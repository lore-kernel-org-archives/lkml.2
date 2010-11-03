Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0KCJIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:08:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0KCJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gpSvZTLbcvt5TK3I5QCmwWOK/iiYi/DIWfEs8t2NLiNFTv9lkZPd3WUbcNFmXCbkJX
         j0nRADj8wMlcawxatN2aKnOslqKh4N/3Dj6BVv6CLuloqcCng8CtKn3gYNi9Yp+MuaVt
         vugBOv3xjG5hQMCSwyoOeUdTvlm3QVIZ+9YiU=
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288773716.23014.124.camel@sli10-conroe>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
	 <1288768330.2467.660.camel@edumazet-laptop>
	 <1288768795.23014.123.camel@sli10-conroe>
	 <1288769123.2467.681.camel@edumazet-laptop>
	 <1288769486.2467.690.camel@edumazet-laptop>
	 <1288773716.23014.124.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 10:08:02 +0100
Message-ID: <1288775282.2511.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 16:41 +0800, Shaohua Li a écrit :

> yes, this is ok. we might need avoid some cpu hotplug race too. I'll
> post a new patch later.
> 
> 

Hmm, maybe only set the variable "must take the lock", never unset it.



