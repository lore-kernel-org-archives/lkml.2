Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab0DNW7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:59:48 -0400
Received: from smtp.infotech.no ([82.134.31.41]:53222 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab0DNW7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:59:46 -0400
Message-ID: <4BC648DC.4060007@interlog.com>
Date: Wed, 14 Apr 2010 18:59:40 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>,
       kumba@gentoo.org,
       =?ISO-8859-1?Q?Dan_H?= =?ISO-8859-1?Q?or=E1k?= 
	<dhorak@redhat.com>
Subject: [ANNOUNCE] sdparm 1.05 available
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
www.t10.org since October 2009. Starting with this version
if libsgutils2 from the sg3_utils package (version 1.29)
is available during the sdparm build then the executable
will depend on that shared object.

ChangeLog for sdparm-1.05 [20100413] [svn: r149]
   - add '--readonly' option especially for '-C start' and
     '-C stop' on ATA disks.
   - Control mode page updates (spc4r23)
   - add Control data protection mode page (ssc4r01)
   - block device characteristics VPD page: decode form factor
   - extended inquiry VPD page: activate_microcode+r_sup (spc4r23)
   - Automation device serial number and Data transfer device
     element address VPD pages (ssc4r01)
   - add SBC Referrals VPD page (sbc3r22)
   - expand SBC Thin provisioning VPD page (sbc3r22)
   - expand SBC Block limits VPD page (sbc3r22)
   - SAS-2.1 specification split, upper layers placed in SPL
     - add enable_slumber and enable_partial fields to
       Enhanced phy control mode page
   - add AM_MAINTAINER_MODE to configure.ac to lessen build issues
   - build infrastructure change to use libsgutils2 if available

ChangeLog for sdparm-1.04 [20090920] [svn: r129]
....


For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html

A release announcement will be sent to freshmeat.net .

Doug Gilbert
