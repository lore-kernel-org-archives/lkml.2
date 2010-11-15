Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0KOWq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:46:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab0KOWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:46:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Date: Mon, 15 Nov 2010 23:46:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
In-Reply-To: <1289065631-2256-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011152346.41458.arnd@arndb.de>
X-Provags-ID: V02:K0:YZX6I84YpW6+U0F+lsPs7dpuTd70B8ARoI3MPw6WIhy
 xwYaZwmX1zWXtIq/dsJYnbSd7oY9AEVnvRXwEiKol6lBVZL9dU
 veUEojn9BGjW82aRO9XggdwlsQLdqcQh5nHuXYAvcjT9VPZ5CS
 PSqpTts3VgAIVwxc1sVAgMnSCY2hA0DW/aWWqDoYHv391XcJ07
 cJoyCn2qOxFqeBcOitUmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 November 2010 18:47:08 Alessio Igor Bogani wrote:
> As reported in udf_sb.h the udf_sb_infoi's structure member s_lvid_dirty should
> be protected by s_alloc_mutex. Added that mutex on a couple of places where it
> miss.
> 
> This work was supported by a hardware donation from the CE Linux Forum.

Any update on this?

I'd really like to see the BKL disabled by default in 2.6.37, and UDF
is the final blocker for this now.

	Arnd
