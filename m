Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1C3HnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:43:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48077 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3HnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FBKd04pwiYzoGSpJkWAwe0Zq9bY2KUvPMsvUs7AZjX0JTRVckC3fVvFmToS26cSfLo
         W/3hZUQsy0u7dKnXgauvgK0WFBZQVJ1eFMSNI9vQ2kaxNE7CEoNCz0NdOHjBt1QX6lVs
         IEMlOY+kmJvg6lJJCLGa8JHAn5L44GGRaGp20=
Date: Wed, 30 Mar 2011 09:42:55 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330074255.GB17523@htj.dyndns.org>
References: <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <4D91C8E7.5070205@kernel.dk>
 <20110329182555.GA22898@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329182555.GA22898@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 02:25:55PM -0400, Christoph Hellwig wrote:
> Btw, is there any need to actually keep the elv_insert interface?
> 
> Itw has two callers in current mainline, two of them hardcode
> ELEVATOR_INSERT_REQUEUE as the reason and could opencode it, and
> the other cases could be merged into __elv_add_request.

Agreed, at this point, the function seems a bit pointless.

Thanks.

-- 
tejun
