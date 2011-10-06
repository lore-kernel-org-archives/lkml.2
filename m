Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487Ab1JFDO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 23:14:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1JFDO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 23:14:26 -0400
Message-ID: <4E8D1D0A.6020003@canonical.com>
Date: Wed, 05 Oct 2011 20:14:18 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz> <20111003225651.GA10257@leaf> <20111004044914.GP6684@thunk.org> <4E8A910D.6020107@zytor.com>
In-Reply-To: <4E8A910D.6020107@zytor.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 09:52 PM, H. Peter Anvin wrote:
> On 10/03/2011 09:49 PM, Ted Ts'o wrote:
>>
>> Note that if your laptop allows incoming ssh connections, and you
>> logged into master.kernel.org with ssh forwarding enabled, your laptop
>> may not be safe.  So be very, very careful before you assume that your
>> laptop is safe.  At least one kernel developer, after he got past the
>> belief, "surely I could have never had my machine be compromised",
>> looked carefully and found rootkits on his machines.
>>
>>        		     	   	       - Ted
> 
> By the way, I'm now pretty convinced that allowing inbound ssh on
> laptops (which is the default on all the mainline Linux distros as far
> as I know) is seriously broken... laptops get connected to *extremely*
> insecure networks on just way too regular a basis.
> 
I can't speak for the other distros but Ubuntu does not enable sshd by
default.  The openssh-server package or ssh meta package must be
installed before sshd will be run.
