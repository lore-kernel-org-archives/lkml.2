Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2DEIow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:44:52 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62596 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2DEIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <1333615097.23520.88.camel@joe2Laptop>
References: <1333569554.864.3.camel@mop> <1333615097.23520.88.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 5 Apr 2012 10:44:29 +0200
Message-ID: <CAPXgP13XZFw6zPL6=pLP=pp7X-hsFetL2pVm1Jj3v6FX-vJTyw@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 10:38, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-04-04 at 21:59 +0200, Kay Sievers wrote:
>> From: Kay Sievers <kay@vrfy.org>
>> + * In a flat text stream of records, every record should be terminated
>> + * by "\n\n", which separates the records from each other.
>
> What do you do about "\n\n" in existing printks?
>
> $ grep -rP --include=*.[ch] '\bprintk\b.*\\n\\n' *

Messages with non-printable characters are exported to the syslog()
syscall or /proc/kmsg as they are, like it always was, but the export
to /dev/kmsg encodes the MESSAGE= property as a binary property then.

Kay
