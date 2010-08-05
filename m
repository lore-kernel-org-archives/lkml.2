Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab0HED1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:27:35 -0400
Received: from claw.goop.org ([74.207.240.146]:57874 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758674Ab0HED1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:27:33 -0400
Message-ID: <4C5A2FA4.6080307@goop.org>
Date: Wed, 04 Aug 2010 20:27:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: William Pitcock <nenolod@dereferenced.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
References: <1278837584.2538.135.camel@edumazet-laptop> <11606525.291278863922663.JavaMail.root@ifrit.dereferenced.org> <20100716065901.GA31612@kroah.com>
In-Reply-To: <20100716065901.GA31612@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/15/2010 11:59 PM, Greg KH wrote:
> On Sun, Jul 11, 2010 at 07:58:42PM +0400, William Pitcock wrote:
>> 2.6.32.16 (possibly 2.6.32.15) has a regression where it is unusable
>> as a Xen domU.  I would say 2.6.32.12 is the best choice since who knows
>> what other regressions there are in .16.
> Did you happen to tell the stable maintainer about this and do a simple
> 'git bisect' to find the offending patch so that it can be resolved?

If it is compiled on Debian then its probably that cmpxchg memory 
argument bug which hits in pvclock.c.

     J
