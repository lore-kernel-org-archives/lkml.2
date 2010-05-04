Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab0EDSB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:01:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61396 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab0EDSBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SMPQw+wwABjOjCR1SqwLe9qsYlsJ4u5J1SHVfPxNLUYxYMcNM3zwSRLWLgzYFOtAuS
         fL2fW6R6s5oSQCSfeFqrpvjkRSi/0JOJipZLYpF9+BroFWxt78n/r/9YEceFwB5oXJDx
         Hvc6GEWqmkKTVo+LktNycXBQPeV/Hp6tLkhr8=
MIME-Version: 1.0
In-Reply-To: <20100504103232.GA25054@infradead.org>
References: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
	 <20100504103232.GA25054@infradead.org>
Date: Tue, 4 May 2010 11:01:22 -0700
Message-ID: <t2gd4f60c3c1005041101o5720e1e4k69b4a7b76296e70f@mail.gmail.com>
Subject: Re: nfs accesses of FAT fs folders causes deadlock on lock_super
From: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 3:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 03, 2010 at 10:59:42PM -0700, Fredrick Prashanth John Berchmans wrote:
>> The box was running kernel version 2.6.27.10.
>> But I think the FAT code has not changed much.
>
> But the nfsd code has and now doesn't call lookup from the filldir
> callback anymore.
>
>

I see from nfsd code, it seems the compose_entry_fh still calls
lookup_one_len, which is now
called from encode_entryplus_baggage instead of entry_encode.
Am I right?
