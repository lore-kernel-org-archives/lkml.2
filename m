Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0IDOmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:42:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0IDOmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:42:52 -0400
Date: Sat, 4 Sep 2010 07:20:26 -0700
From: Greg KH <gregkh@suse.de>
To: CAI Qian <caiqian@redhat.com>
Cc: Dave Anderson <anderson@redhat.com>, guenter.roeck@ericsson.com,
        tj@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: crash failure with 2.6.36-rc3 vmcore
Message-ID: <20100904142026.GA13166@suse.de>
References: <856089343.1931201283439399228.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <223297751.117871283580066858.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223297751.117871283580066858.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 02:01:06AM -0400, CAI Qian wrote:
> 
> > crash> mod -S
> > 
> > mod: invalid structure member offset: attribute_owner
> >      FILE: symbols.c  LINE: 8577  FUNCTION: add_symbol_file_kallsyms()
> > 
> >      MODULE       NAME                   SIZE  OBJECT FILE
> > ffffffffa000de60  dm_mod                76230 
> > /lib/modules/2.6.36-rc2-mm1-wqfix-mkdfix+/kernel/drivers/md/dm-mod.ko
> > [/usr/bin/crash] error trace: 4affb0 => 4f3236 => 4f12b5 => 4e587a
> > 
> >   4e587a: OFFSET_verify.clone.4+186
> >   4f12b5: add_symbol_file+933
> >   4f3236: load_module_symbols+566
> >   4affb0: do_module_cmd+1264
> > 
> > mod: invalid structure member offset: attribute_owner
> >      FILE: symbols.c  LINE: 8577  FUNCTION: add_symbol_file_kallsyms()
> This failure was due to this commit,
> 
> commit 6fd69dc578fa0b1bbc3aad70ae3af9a137211707

<snip>

I don't understand, is this patch causing a problem, or did you forget
to rebuild your code?

confused,

greg k-h
