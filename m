Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0EFQXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:23:39 -0400
Received: from mx1.sophos.com ([195.166.81.52]:54338 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab0EFQXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:23:37 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Testers needed - Maxtor performance degradation
Date: Thu, 6 May 2010 17:23:31 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <Pine.LNX.4.64.1005051433080.30185@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1005051433080.30185@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Message-ID: <201005061723.31390.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/05/2010 17:23:31,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/05/2010 17:23:32,
	Serialize complete at 06/05/2010 17:23:32
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010 17:15:58 Mikulas Patocka wrote:
[snip]
> I'd like to ask other people with Maxtor disks to run this script (with
> "sda", "sdb", etc. as an argument ... without "/dev/" prefix). The script
> measures read rate as a function of request size. Report the results, so
> that it can be determined which disks are buggy and which not and the
> default transfer size could be reduced to 256kB for the buggy ones.

Here is one:

MAXTOR ATLAS10K5_073SAS BP00
64 kB: 86.7 MB/s
128 kB: 86.6 MB/s
192 kB: 86.6 MB/s
256 kB: 86.1 MB/s
320 kB: 39.9 MB/s
384 kB: 41.1 MB/s
448 kB: 41.3 MB/s
512 kB: 44.2 MB/s
576 kB: 49.7 MB/s
640 kB: 42.8 MB/s
704 kB: 47.0 MB/s
768 kB: 46.4 MB/s
832 kB: 59.1 MB/s
896 kB: 55.6 MB/s
960 kB: 57.2 MB/s
1024 kB: 59.3 MB/s

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
