Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1EBUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:16:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45170 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1EBUQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i3mXJztO1TA+ZwlRmBvZbkAEhOIUDqbcF6GPLHnrpwrlCCsa8Aut11KGphtqCdz6AK
         swXNgV9yTv8zdi7Z9c0IUFh84Ijr9wpW0mmALNLyVG1ZwuI1F4CpRN2Tu5JV6/f0Yjck
         TLp3/vbVFM3tT6z7CppCCoHqoAo9sdkHyxOSg=
MIME-Version: 1.0
In-Reply-To: <20110502200730.GA15557@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
	<4DBEEA69.7010000@zytor.com>
	<20110502180802.GA7498@dumpdata.com>
	<4DBEF8EC.7080301@zytor.com>
	<20110502193436.GA14666@dumpdata.com>
	<4DBF0D0C.8000105@zytor.com>
	<20110502200730.GA15557@dumpdata.com>
Date: Mon, 2 May 2011 13:16:26 -0700
X-Google-Sender-Auth: pGuLEg__BheDZoc7HwsD-wnrLDI
Message-ID: <BANLkTi=hXaAuZb54gdgSDrARy84VfkPPvA@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH] Two patches fixing regression introduced
 by 'x86-64, mm: Put early page table high'
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 1:07 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, May 02, 2011 at 12:59:08PM -0700, H. Peter Anvin wrote:
>> >> OK, sounds like a plan then.  I like it because it doesn't affect the
>> >> native kernel.

Xen should set RAM for page-table to RO after init_memory mapping.

>> >
>> > <laughs> I figured :-)
>> >

...

> EST for me, Jeremy is PST (California), Stefano is in UK, so that is UTC+0, and
> no idea where Yinghai is.

California

Thanks

Yinghai
