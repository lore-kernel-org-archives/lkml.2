Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1ISR5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1ISR5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:57:17 -0400
Message-ID: <4E77827C.3030202@redhat.com>
Date: Mon, 19 Sep 2011 11:57:16 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.14
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Josef Bacik <josef@redhat.com>, linux-man@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com>
In-Reply-To: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 01:07 AM, Michael Kerrisk wrote:
> +
> +.BR SEEK_DATA
> +and
> +.BR SEEK_HOLE
> +are nonstandard extensions also present in Solaris.

Looks good to me, but you may also want to link to the proposed wording 
for mandating SEEK_HOLE/SEEK_DATA in the eventual POSIX Issue 8 (POSIX 
2008 is Issue 7):
http://austingroupbugs.net/view.php?id=415

Also, it seems a shame that the kernel can fail with EINVAL instead of 
properly emulating SEEK_HOLE and SEEK_DATA even on file systems with no 
underlying support for reporting holes.

-- 
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org
