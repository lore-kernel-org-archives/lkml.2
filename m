Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2HAT4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:56:49 -0400
Received: from ks35366.kimsufi.com ([213.251.186.122]:53246 "EHLO meetr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2HAT4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:56:46 -0400
Message-ID: <501989F9.9090401@meetr.de>
Date: Wed, 01 Aug 2012 21:56:41 +0200
From: Andreas Heider <andreas@meetr.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
References: <20120710160555.GA31562@srcf.ucam.org>  <20120710163516.GE10194@thinkpad-t410> <4FFCC7FB.1090609@meetr.de>  <1343522547.2488.12.camel@shinybook.infradead.org>  <1343524730.1962.5.camel@shinybook.infradead.org>  <20120729193953.GA25132@srcf.ucam.org>  <1343595171.2511.1.camel@shinybook.infradead.org>  <20120729205859.GA25819@srcf.ucam.org>  <20120731151856.GA19979@thinkpad-t410>  <1343835344.26866.150.camel@shinybook.infradead.org>  <20120801155914.GB22963@thinkpad-t410> <1343850238.26866.171.camel@shinybook.infradead.org>
In-Reply-To: <1343850238.26866.171.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.08.12 21:43, schrieb David Woodhouse:
> On Wed, 2012-08-01 at 10:59 -0500, Seth Forshee wrote:
>> since there still doesn't seem to be any way
>> to get the vbios for the Intel graphics.
>
> Hm, wait. With Matthew's patches to get the Radeon BIOS from EFI, there
> *is* also a ROM image for the Intel device. Have we tried that?
>

If I understand your old dmesg 
(http://david.woodhou.se/dmesg-boot-to-DIS) correctly there is one, but 
it doesn't contain anything useful.

Also there isn't one on my MBP 6,2, see 
http://andreas.meetr.de/efi/log/dh111.txt
