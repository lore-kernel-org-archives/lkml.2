Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1JFExP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 00:53:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46764 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1JFExO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 00:53:14 -0400
References: <4E8655CD.90107@zytor.com> <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz> <20111003225651.GA10257@leaf> <20111004044914.GP6684@thunk.org> <4E8A910D.6020107@zytor.com> <4E8D1D0A.6020003@canonical.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <4E8D1D0A.6020003@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: kernel.org status: establishing a PGP web of trust
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Wed, 05 Oct 2011 21:49:45 -0700
To: John Johansen <john.johansen@canonical.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Message-ID: <2bae51e1-7e99-4cc3-ac3f-bc182030c4cf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good.

John Johansen <john.johansen@canonical.com> wrote:

>On 10/03/2011 09:52 PM, H. Peter Anvin wrote:
>> On 10/03/2011 09:49 PM, Ted Ts'o wrote:
>>>
>>> Note that if your laptop allows incoming ssh connections, and you
>>> logged into master.kernel.org with ssh forwarding enabled, your
>laptop
>>> may not be safe.  So be very, very careful before you assume that
>your
>>> laptop is safe.  At least one kernel developer, after he got past
>the
>>> belief, "surely I could have never had my machine be compromised",
>>> looked carefully and found rootkits on his machines.
>>>
>>>        		     	   	       - Ted
>> 
>> By the way, I'm now pretty convinced that allowing inbound ssh on
>> laptops (which is the default on all the mainline Linux distros as
>far
>> as I know) is seriously broken... laptops get connected to
>*extremely*
>> insecure networks on just way too regular a basis.
>> 
>I can't speak for the other distros but Ubuntu does not enable sshd by
>default.  The openssh-server package or ssh meta package must be
>installed before sshd will be run.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
