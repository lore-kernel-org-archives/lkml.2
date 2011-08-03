Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1HCXhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:37:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43392 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1HCXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:36:38 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 19:36:38 EDT
Message-ID: <4E39D9E1.2080301@interlog.com>
Date: Wed, 03 Aug 2011 19:29:37 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>,
        Martin Pitt <mpitt@debian.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: [Announce] sg3_utils-1.32 available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. It also has
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

A new utility called sg_sanitize has been added and there has
been a major rework of the sg_ses utility. This version tracks
various changes made by www.t10.org since February 2011.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freshmeat.net .

Changelog for sg3_utils-1.32 [20110730] [svn: r410]
   - sg_sanitize: new utility for command added in sb3r27
   - sg_sat_identify: add '--ident' to output WWN
   - sg_ses: major rework of descriptor output
     - add --index, --descriptor, --join, --clear, --get,
       and --set options
   - sg_raw: exit status corrections
   - sg_decode_sense: add --nospace and --hex options
   - sg_logs: fix bug with large --maxlen
     - zero response length when resid implies it is invalid
     - add scope field to lb provisioning lpage (sb3r27)
   - sg_inq: sync version descriptors with spc4r31
   - sg_lib_data: sync asc/ascq codes with spc4r31
   - sg_vpd: add LBPRZ field in LB provisioning VPD page
   - sg_format: allow format of pdt 7 (some MO drives)
   - sg_cmd_basic: sg_cmds_process_resp() handle status good
     with a sense key other than no_sense (e.g. completed)
   - add README.iscsi

Changelog for sg3_utils-1.31 [20110216] [svn: r386]
...

Doug Gilbert

