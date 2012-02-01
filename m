Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2BAOym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:54:42 -0500
Received: from mail.yuiop.co.uk ([89.145.97.74]:40866 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab2BAOyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:54:41 -0500
X-Greylist: delayed 991 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 09:54:41 EST
Message-ID: <4F294E64.10204@anonymous.org.uk>
Date: Wed, 01 Feb 2012 14:38:28 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: thomas@fjellstrom.ca
CC: Simon McNair <simonmcnair@gmail.com>, linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        ayan@marvell.com, andy yan <andyysj@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas with
 3.1)
References: <201201131144.58044.thomas@fjellstrom.ca> <CAKaSfQDyU1a641ZMBNNJJABhXBQxhPGH=E6sNoss=2JyYgFusw@mail.gmail.com> <201202010703.09833.thomas@fjellstrom.ca>
In-Reply-To: <201202010703.09833.thomas@fjellstrom.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2012 14:03, Thomas Fjellstrom wrote:
[...]
>  I picked up a refurb IBM
> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just have to
> wait and see why grub doesn't like it.

When you find out, please let me know - I bought one via ebay, its 
firmware was elderly and wouldn't let me put it in JBOD mode, after a 
bit of googling I flashed it with IBM's latest firmware, then GRUB 
thought my machine had no RAM in it. The card has been sitting in a box 
since.

Cheers,

John.

