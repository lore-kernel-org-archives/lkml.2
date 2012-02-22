Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2BVQnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:43:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37705 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2BVQnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:43:19 -0500
Message-ID: <4F451B02.8030201@linux.vnet.ibm.com>
Date: Wed, 22 Feb 2012 10:42:42 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Alex_Villac=ED=ADs_Lasso?= 
	<a_villacis@palosanto.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: Fwd: Deadlock warning in 3.3-rc4 in zcache code when running
 transmission-gtk
References: <4F42F2FE.5090101@palosanto.com> <4F4515EA.2090909@palosanto.com>
In-Reply-To: <4F4515EA.2090909@palosanto.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022216-6148-0000-0000-000003A8DE1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 10:20 AM, Alex Villací­s Lasso wrote:
> I am getting (potential?) deadlock warnings in zcache code shortly after 
> running transmission-gtk, the bittorrent client. My / partition is ext4, 
> and /home and /DATA (where some torrents are stored) are ext3 mounted 
> with ext4 subsystem. The warning has triggered twice so far, always 
> after running transmission-gtk.
> 
> Fedora 16 x86_64, vanilla linux 3.3-rc4.
> Deadlock warning did not appear in 3.3-rc3.

This may have already been identified and fixed by this patch:
https://lkml.org/lkml/2012/2/20/155

Let me know if that doesn't fix it.

--
Seth

