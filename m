Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0EZUfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:35:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47467 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0EZUfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:35:44 -0400
Message-ID: <4BFD8605.7080201@zytor.com>
Date: Wed, 26 May 2010 13:35:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Q: sys_personality() && misc oddities
References: <20100525141720.GA2253@redhat.com>	<20100525193348.83F1549A54@magilla.sf.frob.com>	<20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com>
In-Reply-To: <20100526203105.59D7849A56@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 01:31 PM, Roland McGrath wrote:
>> As for the other oddities, they need the separate patches. Or we can
>> just leave this code alone ;)
> 
> I can't see any sign that anybody cares.

I certainly care, because we have had some very strange behavior with
weird personality bits in the past.  So cleaning this up would be good.

	-hpa
