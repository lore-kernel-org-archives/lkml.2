Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1CSOrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 10:47:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43031 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1CSOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 10:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rDe+rWa/d2eCXBQ8lEjfKv4VwCIEcopYbAu8OVG5c68EGfR9X3E4zIVNkAxn8dVvlx
         G+K8rZHxH3WQ0LpWufEO8JOrH6mq+I7aBvBH01uMwjN2vlqBA51wj5CG1AaJWLlv8sHz
         XvC/xc5SP7HhOItwnBM9NOLJXtVLNb8YwZLDM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103180942531.2787@localhost6.localdomain6>
References: <20110317213822.GA27980@kroah.com>
	<alpine.LFD.2.00.1103180942531.2787@localhost6.localdomain6>
Date: Sat, 19 Mar 2011 15:47:07 +0100
X-Google-Sender-Auth: Jz_vuuGKsi6Oz6jLBC97l3vNJQc
Message-ID: <AANLkTi=q-HEBKFe=DLXC36Acxd_LqgfYs=66wxs013Ac@mail.gmail.com>
Subject: Re: [000/474] 2.6.33.8-longterm review
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/3/18 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 17 Mar 2011, Greg KH wrote:
>
>> Yeah, I know what you are thinking, "What, 2.6.33, are you crazy?"
>
> Aren't we all crazy ?
>
>> I'd prefer it if you didn't answer that question...
>
> Too late. You should have put this before the question.
>
>> So, if you are using .33, please give this patch a test and let me know
>> if I've messed up anything (hint, I think I did, it's up to you to
>> figure it out, consider it a test to see if anyone actually cares about
>> this kernel version.)
>
> We'll pull it into rt and figure out what breaks.

Can you please elaborate somewhat on the status of the RT-patchset
development for 2.6.38 and on?
It is silent about it for quite a while now, and actually the gap
between mainstream and the latest RT has never been this big before...
Are there major complications, lack on time or hands? Can I help ?

Thanks for the all the effort,

Kind regards,

Remy
