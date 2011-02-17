Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1BQB6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:58:00 -0500
Received: from smtp.infotech.no ([82.134.31.41]:59395 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab1BQB56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:57:58 -0500
Message-ID: <4D5C809E.8010705@interlog.com>
Date: Wed, 16 Feb 2011 20:57:50 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>,
        Martin Pitt <mpitt@debian.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Announce] sg3_utils-1.31 available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. It also has
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version tracks various changes made by www.t10.org
since November 2010. A new utility called sg_decode_sense
has been added.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_dd utility has its own page at:
     http://sg.danny.cz/sg/sg_dd.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freshmeat.net .

Changelog for sg3_utils-1.31 [20110216] [svn: r386]
   - sg_decode_sense: new utility to decode sense data
   - sg_vpd: LB provisioning + Block limits pages (sbc3r26)
   - sync asc/ascq and version descriptors with spc4r28
   - sg_get_config, sg_rmsn, sg_verify: add --readonly option
   - sg_lib: implement forwarded sense data descriptor
     - decode user data segment referral sense data descriptor
   - sg_lib, sg_turs, sg_format: more precision for progress
     indication (two places after decimal point)
   - sg_lib(win32): add runtime selection of SPT direct or
     indirect interface
     - sg_read_buffer+sg_write_buffer: set SPT direct
   - add examples/forwarded_sense.txt + examples/ref_sense.txt

Changelog for sg3_utils-1.30 [20101111] [svn: r363]
...

Doug Gilbert
