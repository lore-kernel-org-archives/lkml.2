Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1DFPU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:20:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60499 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab1DFPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HicMvqkxsc4GxJzieG+9QZ8KtwDnf+DigLS2k+TbkXF5u5kdl1pQU/iNuc5RbL2gAo
         vKpGvi3mhRVVU7xA50P63e77fA4t183ZrMg9anJHa8Xz04vm6J/D0Yeq0p9BI+MTLDgu
         KFpfTuqC3tiPv21nbtsEJP0DHkcWKG8VMEutI=
Message-ID: <4D9C84D5.6090303@gmail.com>
Date: Wed, 06 Apr 2011 09:20:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.39-rc2] perf top fails to mmap
References: <inhgjs$54a$1@dough.gmane.org>
In-Reply-To: <inhgjs$54a$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/06/11 04:51, Tim Blechmann wrote:
> hi all,
> 
> when trying to profile a process with `perf top -p $PID', perf exits with:
> Failed to mmap with 22 (Invalid argument)

Works fine for me with latest kernel tree (this morning). Short lived
process?

David

> 
> this happens when running perf as the same process as the process and when 
> running perf as root.
> 
> tim
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
