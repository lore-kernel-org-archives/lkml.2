Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2DCFjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:39:16 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:41410 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2DCFiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:38:24 -0400
Date: Tue, 3 Apr 2012 07:38:21 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [3.4-rc1 crash]: NULL pointer deref in
 fs/sysfs/group.c:create_files -- sysctl related?
Message-ID: <20120403073821.3cde20e7@pluto.restena.lu>
In-Reply-To: <1333403193.2960.80.camel@laptop>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	<20120402165036.2bc987ad@pluto.restena.lu>
	<m17gxyklfm.fsf@fess.ebiederm.org>
	<20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop>
	<1333403193.2960.80.camel@laptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Apr 2012 23:46:33 Peter Zijlstra wrote:
> On Mon, 2012-04-02 at 23:24 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-04-02 at 21:34 +0200, Bruno Prémont wrote:
> > > > >> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
> > 
> > Is this a netburst based space heater?
> 
> In particular, does: https://lkml.org/lkml/2012/3/27/182 , sort it?
> 
> Ingo, could you pick that one up and route it Linus wards?

It does sort it!

Tested-By: Bruno Prémont <bonbons@linux-vserver.org>
