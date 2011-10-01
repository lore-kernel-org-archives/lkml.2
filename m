Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1JAIsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 04:48:21 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:53779 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1JAIsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 04:48:14 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: CIFS  kernel module bug
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
Date: Sat, 1 Oct 2011 09:48:12 +0100
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@samba.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2> <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
To: Jeremy Allison <jra@samba.org>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 1 Oct 2011, at 01:34, J.P. King wrote:
> Anton will be asleep, so I'll attempt to answer this one.
> 
>> What server code is the OES CIFS server running ? I thought Novell CIFS
>> services were all Samba based.
> 
> We have been told by the people upstairs who run the server that it isn't.

It is not Samba based.  Like Apple, Novell have written their own since Samba decided to go GPLv3…

> I have a recollection that it may be a forked version of the samba code, but don't rely on my recollections.

It is not.  Or it better not be given the license is binary only!!!  It would have to be GPL if it were forked.

> Either way it is sitting on top of NSS, a Novell filesystem, which is significantly different to "normal" Linux filesystem.  I don't know that
> this is the issue, but it is a difference which may affect things regardless of the fileserver code.


I had a quick google and Novell's own OES documentation for CIFS has a section titled:

	"Comparing Novell CIFS and Novell Samba"

If you care, it is on page 77 of this PDF:

	http://www.novell.com/documentation/oes2/pdfdoc/file_cifs_lx/file_cifs_lx.pdf

And our filestore is running the Novell CIFS server, not the Novell Samba one in case that wasn't obvious from previous discussion…

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

