Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0JRM17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:27:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab0JRM16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:27:58 -0400
Message-ID: <4CBC3D44.40008@redhat.com>
Date: Mon, 18 Oct 2010 14:27:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jan Kiszka <jan.kiszka@web.de>, Dave Young <hidave.darkstar@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <20101017085416.GA1758@darkstar>	<4CBAC342.1010609@redhat.com>	 <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>	 <4CBAE8E2.1060704@redhat.com>	 <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>	 <4CBBF3C8.9070104@web.de> <4CBC0B8C.7030003@redhat.com>	 <4CBC0C43.9060302@redhat.com> <1287404813.16971.79.camel@gandalf.stny.rr.com>
In-Reply-To: <1287404813.16971.79.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/18/2010 02:26 PM, Steven Rostedt wrote:
> On Mon, 2010-10-18 at 10:58 +0200, Avi Kivity wrote:
>
> >  >
> >  >  Doesn't parse here.  I get a bus error.
> >  >
> >  >  Steven, is trace.dat meant to be transportable?  What does it depend on?
> >  >
> >  >  Jan, can you upload your parsed data somewhere?  I want to have a look
> >  >  as well.
> >  >
> >
> >  Never mind, user error here.
> >
>
> Everything all set then?

Yes, sorry for the noise.

-- 
error compiling committee.c: too many arguments to function

