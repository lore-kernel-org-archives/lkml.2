Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0JHJ2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:28:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46389 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0JHJ2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lSB7vgeW44dWHGa8Jvcr+CXGXWrqkI1DjJ7dRGt352kIbuREcigc2AtfBRLnRXWqz7
         Hl7GzwQ5JDQFa6zkgMbGUYhCnqFV2B3O1781LaS9ShtX9ngI/CzIJJD/8ZaTqfiYB4Gq
         Nc5/pGQ1uDFeSUUs83kRD1+bvG71JDmBTJXK0=
MIME-Version: 1.0
In-Reply-To: <20101008092427.GA5426@lst.de>
References: <20101006083150.GA15758@zhongling>
	<201010071431.14937.phillips@phunq.net>
	<20101008082231.GA2054@lst.de>
	<AANLkTim9KFuP1_mrUUsMOEspxkfA=SZW2dmTX4WJbfep@mail.gmail.com>
	<20101008092427.GA5426@lst.de>
Date: Fri, 8 Oct 2010 17:28:09 +0800
Message-ID: <AANLkTikK1wiKiCN2N+YdUHtT5XiZx999yePrOO01pHTn@mail.gmail.com>
Subject: Re: introduce dm-snap-mv
From: McPacino <mcpacino@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very very much...


On Fri, Oct 8, 2010 at 5:24 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Oct 08, 2010 at 05:14:27PM +0800, McPacino wrote:
>> Hi Christoph,
>>
>> I have to take care the cache problem If using the bio directly.
>> BHs can be released by kernel when necessary.
>>
>> Is there any existing code using bio to read/write metadata
>> blocks? How do they handle the timing freeing bios? I really
>> wish to learn something form it.
>
> If you actually need caching just use the pagecache, e.g.
> read_mapping_page to read in your data.  That completely abstracts
> away the underlying block size.
>
>
