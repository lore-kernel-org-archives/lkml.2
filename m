Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab1LNT0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:26:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44385 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab1LNT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:26:34 -0500
Message-ID: <4EE8F85B.9060209@landley.net>
Date: Wed, 14 Dec 2011 13:26:19 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: slyich@gmail.com, aboriginal@lists.landley.net,
        linux-kernel@vger.kernel.org, tytso@mit.edu,
        sparclinux@vger.kernel.org, jakub@redhat.com
Subject: Re: Sparc-32 doesn't work in 3.1.
References: <4EE80891.70604@landley.net>	<20111214204225.7c8ec86c@sf.home>	<20111214.125443.973289484729064945.davem@davemloft.net> <20111214.131810.916491563666428853.davem@davemloft.net>
In-Reply-To: <20111214.131810.916491563666428853.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 12:18 PM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 14 Dec 2011 12:54:43 -0500 (EST)
> 
>> The right fix is to simply teach btfixup to be able to patch
>> the 'restore' just as equally as it would patch an 'or'.
> 
> Try this:
> 
> --------------------
> sparc32: Be less strict in matching %lo part of relocation.

Yay!  With that patch, it booted to a shell prompt.

Thanks,

Rob
