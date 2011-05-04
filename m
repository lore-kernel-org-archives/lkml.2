Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1EDTWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1EDTWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:22:09 -0400
Message-ID: <4DC1A75B.7040507@redhat.com>
Date: Wed, 04 May 2011 15:22:03 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost>            <4DC1A49C.4010101@redhat.com> <16280.1304536851@localhost>
In-Reply-To: <16280.1304536851@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 03:20 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 15:10:20 EDT, Josef Bacik said:
>
>> Yeah sorry the log says "nearest" but the code says "next", if you look
>> at it thats how it works.  Thanks,
>
> Oh good - the changelog is usually easier to fix than the code is. :)
>
> Probably want to fix the changelog before it gets committed, as there's a fair
> chance that text will end up being used as the basis for a manpage or other
> documentation.
>

Yeah agreed I meant to change it this time around but forgot, I will 
make the log all nice and pretty next time around, as I doubt this will 
be the last iteration of these patches ;).  Thanks,

Josef
