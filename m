Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2DBVqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:46:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:34687 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2DBVqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:46:47 -0400
Subject: Re: [3.4-rc1 crash]: NULL pointer deref in
 fs/sysfs/group.c:create_files -- sysctl related?
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <1333401898.2960.78.camel@laptop>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	 <20120402165036.2bc987ad@pluto.restena.lu>
	 <m17gxyklfm.fsf@fess.ebiederm.org>  <20120402213440.49e9de74@neptune>
	 <1333401898.2960.78.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Apr 2012 23:46:33 +0200
Message-ID: <1333403193.2960.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 23:24 +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-02 at 21:34 +0200, Bruno Prémont wrote:
> > > >> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
> 
> Is this a netburst based space heater?

In particular, does: https://lkml.org/lkml/2012/3/27/182 , sort it?

Ingo, could you pick that one up and route it Linus wards?

