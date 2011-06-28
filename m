Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1F1TlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:41:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:45950 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1F1TlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:41:16 -0400
Date: Tue, 28 Jun 2011 12:41:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
cc: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        linux-newbie@vger.kernel.org
Subject: Re: Question on syslogd and syslog
In-Reply-To: <BANLkTin_Yo+wnwWyMFoG3Nv5SSzJj8J1_w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1106281238210.7935@asgard.lang.hm>
References: <BANLkTin_Yo+wnwWyMFoG3Nv5SSzJj8J1_w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you would be creating a completely different over-the-wire protocol for 
your syslog messages.

however, note that newer syslog daemons (syslog-ng and rsyslog for 
example) allow you to do filtering on just about anything in the message, 
not just the facility and severity.

David Lang

On Tue, 28 Jun 2011, Sri Ram Vemulpali wrote:

> Date: Tue, 28 Jun 2011 14:11:59 -0400
> From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
> To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
>     linux-newbie@vger.kernel.org
> Subject: Question on syslogd and syslog
> 
> Hello All,
>
>    I am looking to modify number of facilities available in syslog so
> that for my application I can have much more array of them at disposal
> of my need. So currently only LOG_LOCAL0 - LOG_LOCAL7 are defined for
> user, what if I want to extend them, is there a way I can extend them.
> Or should I go ahead and modify the source code of syslog. Can any
> please point me in right direction and where can I get syslogd and
> syslog source code. Thanks in advance.
>
>
