Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0DFOxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:53:22 -0400
Received: from smtp.turknetserver.com ([193.192.122.40]:55439 "EHLO
	smtp.turknetserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab0DFOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:53:16 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 10:53:16 EDT
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/14] Memory Compaction v7
Date: Tue, 6 Apr 2010 17:47:16 +0300
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc3-git4; KDE/4.4.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-9"
Content-Transfer-Encoding: 7bit
Message-Id: <201004061747.16886.tarkan.erimer@turknet.net.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Friday 02 April 2010 07:02:34 pm Mel Gorman wrote:
> The only change is relatively minor and is around the migration of unmapped
> PageSwapCache pages. Specifically, it's not safe to access anon_vma for
> these pages when remapping after migration completes so the last patch
> makes sure we don't.
> 
> Are there any further obstacles to merging?
> 

These patches are applicable to which kernel version or versions ?
I tried on 2.6.33.2 and 2.6.34-rc3 without succeed. 

Tarkan
