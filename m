Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1JAAfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 20:35:06 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:58672 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1JAAep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 20:34:45 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Sat, 1 Oct 2011 01:34:44 +0100 (BST)
From: "J.P. King" <jpk28@cam.ac.uk>
X-X-Sender: jpk28@hermes-2.csi.cam.ac.uk
To: Jeremy Allison <jra@samba.org>
cc: Anton Altaparmakov <aia21@cam.ac.uk>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@samba.org>
Subject: Re: CIFS  kernel module bug
In-Reply-To: <20110930234711.GD14147@samba2>
Message-ID: <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anton will be asleep, so I'll attempt to answer this one.

> What server code is the OES CIFS server running ? I thought Novell CIFS
> services were all Samba based.

We have been told by the people upstairs who run the server that it isn't. 
I have a recollection that it may be a forked version of the samba code, 
but don't rely on my recollections.

Either way it is sitting on top of NSS, a Novell filesystem, which is 
significantly different to "normal" Linux filesystem.  I don't know that
this is the issue, but it is a difference which may affect things 
regardless of the fileserver code.


> Jeremy.

Julian
--
Julian King
Computer Officer, University of Cambridge, Unix Support
