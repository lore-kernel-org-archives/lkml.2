Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0LFJpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:45:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44752 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0LFJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:45:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CFCB078.3030905@jp.fujitsu.com>
Date: Mon, 06 Dec 2010 18:44:24 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: jaxboe@fusionio.com, vgoyal@redhat.com, jmarchan@redhat.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/2 v6] blk: fix a wrong accounting of hd_struct->in_flight
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, Linus, Vivek, Jerome,

Do you remember following problem?

https://lkml.org/lkml/2010/10/24/118

I try to fix a original problem, which is a wrong accounting of
hd_struct->in_flight, by completely rewriting a patch.

Here are patches for fixing the original problem.

  [PATCH 1/2] Don't merge different partition's IOs
  [PATCH 1/2] Change a argument of disk_map_sector_rcu() to
              hd_part->start_sect from req->__sector

For more details, please refer to the header of each patch.

Any comments or questions are welcome.

Thanks.
Yasuaki Ishimatsu

