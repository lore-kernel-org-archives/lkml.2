Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0EFSdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:33:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61197 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0EFSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=PE0oLmbQ8Kjk4ifRHXaHl+Uan+v5tB1lNBGuIM0LemkYf6Ql9UgEZVgrqoejRpPoyn
         pWFrM0oxom4BL/wXL8ZkLfrOX7CMMnsIOzRd92FgeF7HAyqzvisOYpcZ2aqvOWzvQbey
         +T+msd/ZUcCi0+5/5Sc+nddZv5OdhRQktOVlk=
Date: Thu, 6 May 2010 20:32:50 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-scsi@vger.kernel.org
Subject: Re: Testers needed - Maxtor performance degradation
Message-ID: <20100506203250.76f559cd@gmail.com>
In-Reply-To: <Pine.LNX.4.64.1005051433080.30185@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1005051433080.30185@hs20-bc2-1.build.redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 12:15:58 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> I'd like to ask other people with Maxtor disks to run this script (with 
> "sda", "sdb", etc. as an argument ... without "/dev/" prefix). The script 
> measures read rate as a function of request size. Report the results, so 
> that it can be determined which disks are buggy and which not and the 
> default transfer size could be reduced to 256kB for the buggy ones.

ATA MAXTOR STM316021 3.AA
64 kB: 78.9 MB/s
128 kB: 79.1 MB/s
192 kB: 79.1 MB/s
256 kB: 78.6 MB/s
320 kB: 79.1 MB/s
384 kB: 78.9 MB/s
448 kB: 79.0 MB/s
512 kB: 79.1 MB/s
576 kB: 79.0 MB/s
640 kB: 79.1 MB/s
704 kB: 79.0 MB/s
768 kB: 79.1 MB/s
832 kB: 79.0 MB/s
896 kB: 79.0 MB/s
960 kB: 79.1 MB/s
1024 kB: 78.8 MB/s

-- 
	Paolo Ornati
	Linux 2.6.34-rc6-00063-gbe1066b on x86_64
