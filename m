Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2BFVb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:31:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2BFVbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:31:25 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>
Subject: Re: Announce: cancd 0.2.0 netconsole capture server
References: <20120206190206.GA8068@logfs.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 06 Feb 2012 16:31:14 -0500
In-Reply-To: <20120206190206.GA8068@logfs.org> (=?utf-8?Q?=22J=C3=B6rn?=
 Engel"'s message of
	"Mon, 6 Feb 2012 14:02:06 -0500")
Message-ID: <x49mx8vps2l.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> Quoting Documentation/networking/netconsole.txt:
> 	The remote host can run either 'netcat -u -l -p <port>',
> 	'nc -l -u <port>' or syslogd.
>
> Now, both of these options have their issues.  Netcat works fine, but
> only reasonably scales to 1.  Having to use a seperate port for every
> test machine, as well as a seperate netcat process that writes to a
> proper file becomes a bit of a nightmare by the time you approach
> three digits of machines.
>
> Syslogd would be great, if netconsole actually spoke syslog protocol.
> As it is netconsole speaks a protocol I would describe as "7bit ascii,
> no nonsense".  Syslog protocal is described in rfc5424, a 38-page
> document.  I think it is fair to say the two are incompatibel.  In
> case someone actually wants to see the full trainwreck, a quick search
> should come up with enough bug reports to scare your children into
> bed.
>
> Given that sad state of things, here is yet another alternative:
> http://git.kernel.org/?p=linux/kernel/git/joern/cancd.git

Hmm, the old netdump-server package that we used to ship in RHEL should
work too, I think, if you are interested in that approach.  That was
designed specifically to receive netconsole messages and netdumps from
multiple servers.  Google up netdump-server-0.7.16 and you should find
an srpm.  If there's interest in keeping that alive, I can put it up in
some public repo.

Cheers,
Jeff
