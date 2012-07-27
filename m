Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2G0UmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:42:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0UmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:42:06 -0400
Message-ID: <5012FD19.5090100@pobox.com>
Date: Fri, 27 Jul 2012 16:42:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] NVMe: Add a character device for each nvme device
References: <1343407458-29909-1-git-send-email-keith.busch@intel.com> <20120727181212.GM22985@linux.intel.com> <5012EBD9.8010602@pobox.com> <20120727202655.GP22985@linux.intel.com>
In-Reply-To: <20120727202655.GP22985@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 04:26 PM, Matthew Wilcox wrote:
> Maybe we should design such a mechanism, but maybe we shouldn't ... as we
> find common things to do, we tend to move those to sysfs, not ioctls,
> and the kinds of commands that are being sent here are essentially
> vendor-specific NVMe commands; it's not clear they'd fit neatly into a
> generic mechanism.

You're delivering arbitrary packets to the device from userspace, and it 
is returning arbitrary packets to userspace.

This is a familiar pattern...  It is quite analagous to "send 
vendor-specific commands from userspace to a drive"

	Jeff


