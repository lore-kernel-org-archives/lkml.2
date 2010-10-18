Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0JRM05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:26:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0JRM04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:26:56 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=sS0UqdvmdFYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XuRrSHVrhxJ_aLnausAA:9 a=VMB19sav-ZNDmARhRyDAvftWSpAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Dave Young <hidave.darkstar@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4CBC0C43.9060302@redhat.com>
References: <20101017085416.GA1758@darkstar>	<4CBAC342.1010609@redhat.com>
	 <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
	 <4CBAE8E2.1060704@redhat.com>
	 <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
	 <4CBBF3C8.9070104@web.de> <4CBC0B8C.7030003@redhat.com>
	 <4CBC0C43.9060302@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Oct 2010 08:26:53 -0400
Message-ID: <1287404813.16971.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 10:58 +0200, Avi Kivity wrote:

> >
> > Doesn't parse here.  I get a bus error.
> >
> > Steven, is trace.dat meant to be transportable?  What does it depend on?
> >
> > Jan, can you upload your parsed data somewhere?  I want to have a look 
> > as well.
> >
> 
> Never mind, user error here.
> 

Everything all set then?

-- Steve


