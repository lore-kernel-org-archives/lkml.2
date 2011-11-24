Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1KXVb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:31:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56992 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab1KXVb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <4ECD67C7.3010702@hp.com>
References: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com>
	<CAFLxGvynabpEcX2RwiLxatjOEzizj95jAVY6E4D9ymDpn8s9UA@mail.gmail.com>
	<CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com>
	<20111123.160143.58902472755124590.davem@davemloft.net>
	<4ECD67C7.3010702@hp.com>
Date: Thu, 24 Nov 2011 22:31:55 +0100
Message-ID: <CAFLxGvzAV9ODxo6Bs=ow1J0JRwHYNFmkBqrmN33D7Ci=YvNKNg@mail.gmail.com>
Subject: Re: Finding a hidden bound TCP socket
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: David Miller <davem@davemloft.net>, gdfuego@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:38 PM, Rick Jones <rick.jones2@hp.com> wrote:
> On 11/23/2011 01:01 PM, David Miller wrote:
>>
>> From: "G. D. Fuego"<gdfuego@gmail.com>
>> Date: Wed, 23 Nov 2011 15:27:33 -0500
>>
>>> Any comments?  The behavior seems broken.  At the very least its very
>>> inconsistent with other Unixes.
>>
>> Until the socket has a full final tuple it is bound to, there is no
>> reason to list it.
>>
>> No UNIX lists a socket which is partially bound and hasn't either
>> performed a listen() or a connect().
>
> Well....  I took the .c file mentioned previously, and compiled it on a
> Solaris 10 8/11 instance.  The 25-odd sockets it created *were* listed in
> the output of netstat -an -- local address as *.<portnum> remote address as
> *.* and a state of "BOUND."
>
> A FreeBSD  (rev 8 IIRC) netstat -an seems to display them in a state of
> "CLOSED."  I didn't check HP-UX 11i v3 or AIX 6.
>

IRIX (6.5) shows them as "CLOSED".

-- 
Thanks,
//richard
