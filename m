Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2CTHIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:08:38 -0400
Received: from mail-pz0-f66.google.com ([209.85.210.66]:59954 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2CTHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:08:36 -0400
Message-ID: <4F682CF0.2080206@gmail.com>
Date: Tue, 20 Mar 2012 15:08:32 +0800
From: "Teo En Ming (Zhang Enming)" <ubuntu.fan.2012@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ubuntu.fan.2012@gmail.com
Subject: [REQUEST] Request for Hosting My Xen and Linux Kernel HowTo/Tutorial/Documentation
 on www.xen.org and Xen Wiki
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Admins,

I have spent several days writing my Xen and Linux Kernel 
HowTo/Tutorial/Documentation and also testing the XL domain 
configuration files to make sure they work. I have also verified that 
creating virtual machines with Virtual Machine Manager/libvirt works. I 
have done a lot of testing with my Xen and Linux Kernel documentation.

There are 4 bugs with Xen 4.2-unstable changeset 25070:

1. In Xen 4.2-unstable, xend service does not start the HTTP listening 
service on port 8000, so Virtual Machine Manager/libvirt does not work 
in Xen 4.2-unstable.

2. In Xen 4.2-unstable, I am unable to start Linux PV guests. Linux PV 
guests exit immediately after starting. But I am able to start Linux PV 
guests successfully in Xen 4.1.3-rc1-pre. The bug is with xl.

3. Installing Ubuntu 12.04 Beta 1 amd64 HVM domU hangs at copying files.

4. (Xen 4.1.3-rc1-pre) The performance of Fedora 16 x86-64 
paravirtualized domU is VERY POOR and VERY SLOW. Mouse cursor does not 
show. Maybe XL configuration problem. usb=1 and usb="tablet"???

The title of my Xen and Linux Kernel documentation is:

Building and Installing Xen 4.x and Linux Kernel 3.x on Ubuntu and 
Debian Linux

My Xen and Linux Kernel documentation includes the following topics:

1. Building the latest Linux Kernel 3.x

2. Building Xen 4.1.3 and Xen 4.2-unstable

3. Installing Virtual Machine Manager/libvirt

4. Shorewall Firewall Configuration for Xen networking

5. XL Domain Configuration Files for Windows 8 Consumer Preview HVM, 
Windows XP HVM, Fedora 16 PV domU, and Ubuntu 12.04 Precise Pangolin 
Beta 1 HVM

6. Brief overview on Xen VGA Passthrough (reference to David Techer's blog).

7. Linux Kernel Configuration Files for 3.3.0-rc7, 3.2.11, 3.3.0, and 
3.2.12.

I have finished writing my Xen and Linux Kernel documentation after 
several days and the latest version of the HTML and PDF document is 
version 1.3.

Could you accede to my request by hosting my Xen and Linux Kernel HTML 
and PDF documentation onwww.xen.org and the Xen Wiki?

Download Links
==========

Version 1.0: 
http://www.sgvideoman.com/xen/docs/Building%20and%20Installing%20Xen%204.x%20and%20Linux%20Kernel%203.x%20on%20Ubuntu%20and%20Debian%20Linux%20-%20Version%201.0.pdf

Version 1.1: 
http://www.sgvideoman.com/xen/docs/Building%20and%20Installing%20Xen%204.x%20and%20Linux%20Kernel%203.x%20on%20Ubuntu%20and%20Debian%20Linux%20-%20Version%201.1.pdf

Version 1.2: 
http://www.sgvideoman.com/xen/docs/Building%20and%20Installing%20Xen%204.x%20and%20Linux%20Kernel%203.x%20on%20Ubuntu%20and%20Debian%20Linux%20-%20Version%201.2.pdf
**
Version 1.3:

(a) 
http://www.sgvideoman.com/xen/docs/Building%20and%20Installing%20Xen%204.x%20and%20Linux%20Kernel%203.x%20on%20Ubuntu%20and%20Debian%20Linux%20-%20Version%201.3.pdf

(b) 
http://www.sgvideoman.com/xen/docs/Building%20and%20Installing%20Xen%204.x%20and%20Linux%20Kernel%203.x%20on%20Ubuntu%20and%20Debian%20Linux%20-%20Version%201.3.html

Thank you very much for your consideration and kind assistance.

Yours sincerely,

Teo En Ming (Zhang Enming)

