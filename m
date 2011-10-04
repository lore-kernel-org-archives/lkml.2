Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1JDExP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 00:53:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1JDExO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 00:53:14 -0400
Message-ID: <4E8A910D.6020107@zytor.com>
Date: Mon, 03 Oct 2011 21:52:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz> <20111003225651.GA10257@leaf> <20111004044914.GP6684@thunk.org>
In-Reply-To: <20111004044914.GP6684@thunk.org>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 09:49 PM, Ted Ts'o wrote:
> 
> Note that if your laptop allows incoming ssh connections, and you
> logged into master.kernel.org with ssh forwarding enabled, your laptop
> may not be safe.  So be very, very careful before you assume that your
> laptop is safe.  At least one kernel developer, after he got past the
> belief, "surely I could have never had my machine be compromised",
> looked carefully and found rootkits on his machines.
> 
>        		     	   	       - Ted

By the way, I'm now pretty convinced that allowing inbound ssh on
laptops (which is the default on all the mainline Linux distros as far
as I know) is seriously broken... laptops get connected to *extremely*
insecure networks on just way too regular a basis.

	-hpa
