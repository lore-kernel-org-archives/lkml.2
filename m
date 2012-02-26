Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2BZM4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 07:56:47 -0500
Received: from mail.yuiop.co.uk ([89.145.97.74]:37227 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2BZM4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 07:56:45 -0500
Message-ID: <4F4A2C37.3090500@anonymous.org.uk>
Date: Sun, 26 Feb 2012 12:57:27 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: thomas@fjellstrom.ca
CC: Simon McNair <simonmcnair@gmail.com>, linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        ayan@marvell.com, andy yan <andyysj@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Solved (for me at least!) GRUB doesn't like ServeRAID M1015/LSI 9220-8i
References: <201201131144.58044.thomas@fjellstrom.ca> <CAKaSfQDyU1a641ZMBNNJJABhXBQxhPGH=E6sNoss=2JyYgFusw@mail.gmail.com> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk>
In-Reply-To: <4F294E64.10204@anonymous.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2012 14:38, John Robinson wrote:
> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
> [...]
>> I picked up a refurb IBM
>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just
>> have to
>> wait and see why grub doesn't like it.
>
> When you find out, please let me know - I bought one via ebay, its
> firmware was elderly and wouldn't let me put it in JBOD mode, after a
> bit of googling I flashed it with IBM's latest firmware, then GRUB
> thought my machine had no RAM in it. The card has been sitting in a box
> since.

RHEL/CentOS 5's GRUB is buggy, in that it doesn't always read the whole 
of the BIOS's memory map. See 
https://bugzilla.redhat.com/show_bug.cgi?id=445893 and in particular 
comment 7 where there's a link to a replacement GRUB which incorporates 
the patch that was first offered to Red Hat in July 2007. The issue 
likely affects other distros GRUBs too, since GRUB is moribund.

Cheers,

John.

