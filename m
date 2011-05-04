Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1EDVzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:55:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39535 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1EDVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:55:30 -0400
Message-ID: <4DC1CB46.3070805@oracle.com>
Date: Wed, 04 May 2011 16:55:18 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110429 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost> <4DC1A49C.4010101@redhat.com> <4DC1CB06.9060101@oracle.com>
In-Reply-To: <4DC1CB06.9060101@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DC1CB51.0063:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 04:54 PM, Dave Kleikamp wrote:

> The comments in fs.h say "closest". You may want to change them to
> "next" as well.

Sorry.  Missed some of the replies before I responded.  Already addressed.

Shaggy
