Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2JEHom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:44:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2JEHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:44:41 -0400
Message-ID: <506E8FD7.5070203@canonical.com>
Date: Fri, 05 Oct 2012 15:44:23 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, glin@suse.com,
        Lee@grenadilla.canonical.com, Matthew Garrett <mjg@redhat.com>,
        Peter Jones <pjones@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 2/3] efi: add efivars kobject to efi sysfs folder
References: <1349416496.810874.88263724621.2.gpush@pecola> <1349419878.7884.15.camel@linux-s257.site>
In-Reply-To: <1349419878.7884.15.camel@linux-s257.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joey,

> Since more people prefer to use "efivarfs", so, I modified the patch for
> replace "efivars" to "efivarfs" like following:

I'd intentionally left this patch as-is. I think that the filesystem 
should be called "efivarfs", while the directory should be called 
"efivars". Same style as sysfs -> /sys.

Cheers,


Jeremy

