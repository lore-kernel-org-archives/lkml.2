Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1CVRqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab1CVRqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:46:17 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: "Alex\,Shi" <alex.shi@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        "Li\, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso\@mit.edu" <tytso@mit.edu>,
        "jaxboe\@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen\, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
References: <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
	<x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
	<20110302094246.GA7496@quack.suse.cz>
	<x491v2p4i0u.fsf@segfault.boston.devel.redhat.com>
	<20110302211748.GF7496@quack.suse.cz>
	<x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
	<20110304153248.GC2649@quack.suse.cz>
	<x49d3m6j35j.fsf@segfault.boston.devel.redhat.com>
	<x491v2mivv6.fsf@segfault.boston.devel.redhat.com>
	<1300779499.30136.353.camel@debian>
	<20110322161405.GB19716@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Mar 2011 13:46:06 -0400
In-Reply-To: <20110322161405.GB19716@quack.suse.cz> (Jan Kara's message of
	"Tue, 22 Mar 2011 17:14:05 +0100")
Message-ID: <x49r59zrqu9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> Jeff, I suppose the log files of fs_mark processes are on the same
> device as the test directory, aren't they - that might explain the
> flusher thread doing IO? The patch below

No.  My test environments are sane.  The file system is on a completely
separate disk and it is unmounted and remounted in between each run.
That should take care of any lost flushes.

Did you receive my last couple of private emails commenting on the trace
data?

Cheers,
Jeff
