Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2DBVcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:32:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35164 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2DBVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:32:54 -0400
Subject: Re: [3.4-rc1 crash]: NULL pointer deref in
 fs/sysfs/group.c:create_files -- sysctl related?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <20120402213440.49e9de74@neptune>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	 <20120402165036.2bc987ad@pluto.restena.lu>
	 <m17gxyklfm.fsf@fess.ebiederm.org>  <20120402213440.49e9de74@neptune>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Apr 2012 23:24:58 +0200
Message-ID: <1333401898.2960.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 21:34 +0200, Bruno Prémont wrote:
> > >> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4

Is this a netburst based space heater?

