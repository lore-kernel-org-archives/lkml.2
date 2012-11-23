Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2KWReY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:34:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35876 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab2KWReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:34:22 -0500
Message-ID: <50AFB397.5040004@oracle.com>
Date: Fri, 23 Nov 2012 11:34:15 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 01/31] iov_iter: move into its own file
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com> <1353537671-26284-2-git-send-email-dave.kleikamp@oracle.com> <20121123081427.GA10731@infradead.org>
In-Reply-To: <20121123081427.GA10731@infradead.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 02:14 AM, Christoph Hellwig wrote:
> On Wed, Nov 21, 2012 at 04:40:41PM -0600, Dave Kleikamp wrote:
>> From: Zach Brown <zab@zabbo.net>
>>
>> This moves the iov_iter functions in to their own file.  We're going to
>> be working on them in upcoming patches.  They become sufficiently large,
>> and remain self-contained, to justify seperating them from the rest of
>> the huge mm/filemap.c.
>>
>> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
>> Acked-by: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Zach Brown <zab@zabbo.net>
> 
> Is this mm or fs code?  I'd be tempted to have the file in fs/.

I have no objection. If nobody else objects, I'll move it there instead.

Shaggy
