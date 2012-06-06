Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2FFAjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:39:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54114 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2FFAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:39:05 -0400
Date: Tue, 5 Jun 2012 19:38:56 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jcliburn@gmail.com, chris.snook@gmail.com,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Message-ID: <20120606003856.GA7839@burratino>
References: <1329063403.1449.14.camel@localhost.localdomain>
 <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com>
 <1329204997.24837.15.camel@edumazet-laptop>
 <1329366846.5646.1.camel@edumazet-laptop>
 <1329847015.5133.4.camel@localhost.localdomain>
 <1329848093.18384.35.camel@edumazet-laptop>
 <1330111229.15610.50.camel@edumazet-laptop>
 <1330163565.1419.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330163565.1419.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In February, 2012, Thomas Meyer wrote:
> Am Freitag, den 24.02.2012, 20:20 +0100 schrieb Eric Dumazet:

>> Here is a cumulative patch to hopefuly remove the races in this driver,
>> could you please test it ?
[...]
> just building a 3.2.7 kernel with your patch applied. I will watch out
> for the warning in the next days.

Well, did it work? :)

In suspense,
Jonathan
