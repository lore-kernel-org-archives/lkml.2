Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1EJOnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:43:25 -0400
Received: from smtp.infotech.no ([82.134.31.41]:36367 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab1EJOnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:43:24 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 10:43:23 EDT
Message-ID: <4DC94CEB.2000404@interlog.com>
Date: Tue, 10 May 2011 10:34:19 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>,
        Matt Taggart <taggart@debian.org>,
        "Martin K. Petersen" <martin.petersen@ORACLE.COM>
Subject: [ANNOUNCE] lsscsi-0.25 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format which is one line per device and a "classic"
format (like the output of 'cat /proc/scsi/scsi') are supported.

Version 0.25 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm and deb packages.

There have only been superficial changes to the beta release
of 0.25 made in March 2011. The only adverse report was a
problem when a kernel was configured with both
CONFIG_SYSFS_DEPRECATED and CONFIG_SYSFS_DEPRECATED_V2.

The most commonly useful addition is the '--size' option:
$ lsscsi -s
[0:0:0:0]  disk  ATA    INTEL SSDSA2M080 2CV1  /dev/sda  80.0GB
[6:0:0:0]  disk  Linux  scsi_debug       0004  /dev/sdb  4.29PB


ChangeLog:
Version 0.25 2011/05/09 [svn: r92]
   - add sas_port and fc_remote_ports transport information
   - print enclosure_device entry
   - add '--size' option to show size of disks
   - add '--protmode' option to show protection information mode

Version 0.24 2010/06/12 [svn: r83]
...

Doug Gilbert
