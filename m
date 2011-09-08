Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1IHPNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:13:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40078 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1IHPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:13:45 -0400
Message-ID: <4E68DBA5.6010307@vflare.org>
Date: Thu, 08 Sep 2011 11:13:41 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] Fix sparse warnings
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org> <1315445357-14338-2-git-send-email-ngupta@vflare.org> <4E687A33.1080401@redhat.com>
In-Reply-To: <4E687A33.1080401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 04:17 AM, Jerome Marchand wrote:
> On 09/08/2011 03:29 AM, Nitin Gupta wrote:
>> ---
>
> I'm afraid this patch is missing a description.
>

Since it just fixes couple of trivial sparse warnings,
I though no description is necessary? Anyways, here is
the description if needed for patch process:

Fixed some sparse warnings by making zram_slot_free_notify()
static and max_zpage_size as size_t.

---
Thanks,
Nitin

