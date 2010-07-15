Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469Ab0GOTEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:04:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60000 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457Ab0GOTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:04:20 -0400
Date: Thu, 15 Jul 2010 15:03:09 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: csum errors
Message-ID: <20100715190309.GI8623@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
 <201007111428.10005.johannes.hirte@fem.tu-ilmenau.de>
 <201007131423.59415.johannes.hirte@fem.tu-ilmenau.de>
 <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C3F5BAE.0242:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 08:30:17PM +0200, Johannes Hirte wrote:
> Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
> > ino 1959333 off 898342912 csum 4271223884 private 4271223883
> 
> I think, this is a different error. I've only seen them on filesystems from my 
> Opteron system. It seems that the recorded csums are wrong and it looks to me 
> like rounding errors. The data itself should be correct, as I've tested one 
> affected file via md5sum against the original on another filesystem.
> Any ideas what is going wrong here?

Are you doing data mirroring?

We can map that block and do a raw read off the device to see what the
data blocks actually contain.

-chris
