Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab0KLPWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:22:16 -0500
Received: from smtp.infotech.no ([82.134.31.41]:37919 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab0KLPWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:22:14 -0500
Message-ID: <4CDD5BA1.9040100@interlog.com>
Date: Fri, 12 Nov 2010 10:22:09 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>,
        kumba@gentoo.org, =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] sdparm 1.06 available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Almost all CD/DVD/BD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the linux
kernel 2.4 and 2.6 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since April 2010. Note that "thin provisioning"
has been renamed to "logical block provisioning" causing
some mode pages and fields to change names.

For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html


ChangeLog for sdparm-1.06 [20101031] [svn: r166]
   - allow upper and lower case in field, (mode and vpd) page,
     vendor, transport or command matching
   - control mode page: add ATMPE and RWWP fields (spc4r27)
   - extended inquiry vpd page: add extended self test
     completion minutes field (spc4r27)
   - power control mode page: PM_BG_PRECEDENCE field (spc4r24)
     - FIDCPC, FSBCPC, FSTCPC fields (spc4r25)
   - sbc3r25 renames 'thin' provisioning' to 'logical block
     provisioning'; changes mode+vpd page and field names
     - add Application tag mode page
     - add SITPUA bit to logical block provisioning mode page
   - fix '-eal' problem with vendor pages
   - point svn:externals to rev 334 of sg3_utils

ChangeLog for sdparm-1.05 [20100413] [svn: r149]
...


Doug Gilbert
