Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0FHXhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 19:37:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58664 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab0FHXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 19:36:59 -0400
Message-ID: <4C0ED401.6060800@oracle.com>
Date: Tue, 08 Jun 2010 16:36:33 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad
 one
References: <bug-16009-13546@https.bugzilla.kernel.org/> <4C0813D7.7080900@oracle.com> <20100608144350.366071fd@virtuousgeek.org> <201006081649.00332.bjorn.helgaas@hp.com>
In-Reply-To: <201006081649.00332.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4C0ED419.004E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 03:48 PM, Bjorn Helgaas wrote:
> On Tuesday, June 08, 2010 03:43:50 pm Jesse Barnes wrote:

> 
> In this case, the aperture *size* from the BIOS is actually OK, but
> the beginning of the aperture overlaps system memory.  With Yinghai's
> patch, we reduce the size and move the start.  Windows was able to
> just move the start of the aperture and preserve the original
> 0x20000000 size (but I think it had to move something else out of
> the way).

are you sure? that looks more aggressive.

Yinghai
