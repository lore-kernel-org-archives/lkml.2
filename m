Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2EKQBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:01:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57494 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2EKQBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:01:52 -0400
Message-ID: <1336752105.1017.29.camel@twins>
Subject: Re: Commit cb83b62 fails to boot with a divide by zero error.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 18:01:45 +0200
In-Reply-To: <20120511155549.GI3751@sgi.com>
References: <20120511133938.GG3751@sgi.com> <1336746790.1017.17.camel@twins>
	 <20120511150533.GH3751@sgi.com> <1336750573.1017.25.camel@twins>
	 <20120511155549.GI3751@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 10:55 -0500, Robin Holt wrote:
> 
> It is a four blade (8 socket 80 core 160 hyper-thread machine) with 40
> GB of RAM.

Ok, big but not ridiculously so.. I'll try and see if I can find
anything.

> Looking at the earlier kernel messages, I am wondering if I don't have a
> BIOS that is giving me crud.  I have messages about hyperthreads being
> on different nodes.  That had not been happening in the past.  I don't
> have access to the machine now, but the BIOS string that had printed
> out is from a developer's debug version.
> 
> When I get access to the machine again (likely not until Monday), I
> will flash a release BIOS and retest.  Until then, please feel free to
> ignore me. 

No need, that's another (known) bug.. 

  http://marc.info/?l=linux-kernel&m=133673488311294&w=2


