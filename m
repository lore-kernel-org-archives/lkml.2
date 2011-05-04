Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1EDTKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1EDTKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:10:22 -0400
Message-ID: <4DC1A49C.4010101@redhat.com>
Date: Wed, 04 May 2011 15:10:20 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost>
In-Reply-To: <15392.1304535887@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 03:04 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:
>
>> -SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
>> given position.
>
> Nearest, or next? Solaris defines it as "next", for a good reason - otherwise
> you can get stuck in a case where the "nearest" hole is back towards the
> start of the file - and "seek data" will bounce back to the next byte at
> the other end of the hole.
>

Yeah sorry the log says "nearest" but the code says "next", if you look 
at it thats how it works.  Thanks,

Josef
