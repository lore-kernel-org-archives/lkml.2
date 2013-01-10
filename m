Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3AJENZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 23:13:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3AJENY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 23:13:24 -0500
Message-ID: <1357791191.5841.8.camel@marge.simpson.net>
Subject: Re: kernel BUG at kernel/sched_rt.c:493!
From: Mike Galbraith <bitbucket@online.de>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org
Date: Thu, 10 Jan 2013 05:13:11 +0100
In-Reply-To: <20130108150153.GA2219@BohrerMBP.rgmadvisors.com>
References: <20130105174632.GB19226@u1004.rgmadvisors.com>
	 <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
	 <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
	 <20130108143605.GB5594@home.goodmis.org>
	 <20130108150153.GA2219@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:vpxlZjpsLXYy2H2FuP7G5EHMjfYBPKcpe4AYCDW2P0d
 a7Ri1zkxYJueNeVGhohElA1a8pz6xOr6k7TQOEC4xbK0i6TnFl
 lOQ8xUbtZkep2DmLZ2DWDdSC4v5zacI38Urz1PVVoMzUxkAaWa
 CEIftCMQDE5Bgt2uzMK7roX9UYZp/ZtklzM7OdKId81sLg0pR4
 B7rIm2UF/6bS4ePKxkru9nh9Qpu++eFoAW6gw6E+9LmrAGqFQL
 1TPhEj4Al30IKKwQM9Qvfq7jwxYIspAAAhjYzvAXHkmprSrciG
 dA3uFXyF3MTaz/5oT469fnVrFWdbdriS/ukT1sfrHllEh2o5rk
 RyRl1WMZLyEw/6s5nQtd3PoCSbpphMcGBt1hm6iF0GUUwi16/R
 XYwavXxftSKQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 09:01 -0600, Shawn Bohrer wrote: 
> On Tue, Jan 08, 2013 at 09:36:05AM -0500, Steven Rostedt wrote:
> > > 
> > > I've also managed to reproduce this on 3.8.0-rc2 so it appears the bug
> > > is still present in the latest kernel.
> > 
> > Shawn,
> > 
> > Can you send me your .config file.
> 
> I've attached the 3.8.0-rc2 config that I used to reproduce this in an
> 8 core kvm image.  Let me know if you need anything else.

I tried beating on my little Q6600 with no success.  I even tried
setting the entire box rt, GUI and all, nada.

Hm, maybe re-installing systemd..

-Mike

