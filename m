Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2JNWwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 18:52:18 -0400
Received: from smtp.infotech.no ([82.134.31.41]:59620 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab2JNWwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 18:52:17 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2012 18:52:17 EDT
Message-ID: <507B4052.5000102@interlog.com>
Date: Sun, 14 Oct 2012 18:44:34 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>,
        Martin Pitt <mpitt@debian.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [Announce] sg3_utils-1.34 available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 3, 2.6 and lk 2.4 series. It also has
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version adds sg_xcopy and sg_copy_results (contributed by
Hannes Reinecke). This version tracks various changes made by
www.t10.org since January 2012.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freecode.com .

Changelog for sg3_utils-1.34 [20121013] [svn: r461]
   - sg_xcopy: new dd like utility for extended copy command
   - sg_copy_results: new utility for receive copy results
   - sg_verify: add 16 byte cdb, bytchk (data-out buffer)
     and group number support
   - sync to spc4r36 and sbc3r32
   - sg_inq: add --export so sg_inq can replace udev's scsi_id
     - decode old EMC Symmetrix abuse of VPD page 0x83
   - sg_vpd: decode old EMC Symmetrix abuse of VPD page 0x83
   - sg_ses: increase max dpage response size to 64 KB
     - allow ident,locate on enclosure controller
     - more sanity for additional element status descriptor
   - sg_sanitize: add --ause, --fail and --test=
   - sg_luns: add long extended flat space addressing format
   - sg_logs: add ATA pass-through results lpage (SAT-2)
   - sg_rtpg: add --extended option
   - sg_senddiag: list rebuild assist diag page name
   - sg_pt_linux: expand DID_ (host_byte) codes
     - cope with a transport error plus sense data
     - prefer major() over MAJOR() macro
   - sg_lib: fix sg_get_command_name() service actions
     - report sdat_ovfl bit (if set) in sense data
     - decode extended_copy and receive_copy service actions
     - decode read_buffer and write_buffer modes
     - decode ATA PT fixed format sense (SAT-2)
   - sg_cmds_extra: add sg_ll_report_tgt_prt_grp2()
   - ./configure options:
     - change --enable-no-linux-bsg to --disable-linuxbsg
     - add --disable-scsistrings to reduce utility sizes

Changelog for sg3_utils-1.33 [20120118] [svn: r435]
...

Doug Gilbert
