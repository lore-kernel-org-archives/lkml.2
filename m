Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1CVM7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab1CVM73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:59:29 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
References: <1300392635.17266.5.camel@mulgrave.site>
	<AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
	<yq1fwqfu6dd.fsf@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Mar 2011 08:59:14 -0400
In-Reply-To: <yq1fwqfu6dd.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 22 Mar 2011 00:27:42 -0400")
Message-ID: <x49zkons44d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Geert" == Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
> Geert> drivers/scsi/sd.c: In function ‘sd_prep_fn’:
> Geert> drivers/scsi/sd.c:544: warning: ‘ret’ may be used uninitialized
> Geert> in this function
>
> Sorry about that.
>
>
> sd: Fail discard requests when logical block provisioning has been disabled
>
> Ensure that we kill discard requests after logical block provisioning
> has been disabled in sysfs.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

Tao Ma posted a similar patch.  Anyway, either looks good to me.  This
one will avoid an unecessary extra setting of ret, but I doubt that
matters.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
