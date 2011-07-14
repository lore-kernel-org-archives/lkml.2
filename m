Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1GNDZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:25:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49153 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1GNDZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:25:02 -0400
Message-ID: <4E1E6155.6090903@vflare.org>
Date: Wed, 13 Jul 2011 20:24:05 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/4] Staging: zram: Refactor zram_read/write() functions
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com> <1307712529-9757-2-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-2-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 06:28 AM, Jerome Marchand wrote:
> This patch refactor the code of zram_read/write() functions. It does
> not removes a lot of duplicate code alone, but is mostly a helper for
> the third patch of this series (Staging: zram: allow partial page
> operations).
>
> Signed-off-by: Jerome Marchand<jmarchan@redhat.com>

This and patch [3/4] are needed for zram to properly support systems 
with 64k pages,

FWIW.

Acked-by: Nitin Gupta <ngupta@vflare.org>


Nitin
