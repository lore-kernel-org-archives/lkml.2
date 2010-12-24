Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0LXWnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 17:43:31 -0500
Received: from smtp.infotech.no ([82.134.31.41]:53490 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab0LXWna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 17:43:30 -0500
Message-ID: <4D15220C.30705@interlog.com>
Date: Fri, 24 Dec 2010 17:43:24 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] lsscsi-0.24 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format which is one line per device and a "classic"
format (like the output of 'cat /proc/scsi/scsi') are supported.

Version 0.24 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm and deb packages.

There have only been superficial changes to the beta release
of 0.24 made in June 2010.

ChangeLog:
Version 0.24 2010/06/12 [svn: r83]
   - FC transport syntax changes (colon to slash)
   - add "(null)" to the currently accepted "<NULL>" as
     the string representation of NULL
   - add AM_MAINTAINER_MODE to configure.ac
   - scandir() library function has changed its signature
     in its 4th argument, use newer (non-void) variant
Version 0.23 2009/12/01 [svn: r76]
...

Doug Gilbert
