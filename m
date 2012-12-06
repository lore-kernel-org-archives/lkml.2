Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab2LFKgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:36:40 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61582 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2LFKgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:36:39 -0500
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 05:36:39 EST
Message-ID: <50C06EC3.20002@redhat.com>
Date: Thu, 06 Dec 2012 11:09:07 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_ram: a RAM-based SCSI driver
References: <1354725918-14713-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1354725918-14713-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/12/2012 17:45, Kirill A. Shutemov ha scritto:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> This driver is intended to run as fast as possible, hence the options to
> discard writes and reads. It's designed to let us find latency issues
> elsewhere in the storage stack (eg filesystem, block layer, scsi layer).
> 
> There are a few different options, controlled through module parameters.
> The sector size and disc capacity are load-time parameters, but the
> parameters affecting performance are tweakable at runtime.
> 
> By default, it'll allocate half a gigabyte of RAM to use as a ramdisc;
> you can change this with the `capacity' module parameter.

Is this that much faster than scsi-debug?  The discarding options surely
can be added there.

Paolo
