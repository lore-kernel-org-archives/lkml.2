Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1BPSv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:51:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39101 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab1BPSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=heVf5kh7NDlp3Q189rrmydoiiCZc0ODKcGoMHrm0rlyWwboNccmybybQx7unCTCbpE
         Gb/5QYHPCJo3XF5SIm30ncO50DT5sUArYCUmNrYls/6Obcu/HTF7D/TaaE5fFl9PrM4T
         rfr0L78ovV1BWPjpfY+TiypcKEzn3yq987Sqg=
MIME-Version: 1.0
In-Reply-To: <20110216155422.GA4056@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
	<1294420304-24811-5-git-send-email-konrad.wilk@oracle.com>
	<20110127212001.GC4542@dumpdata.com>
	<AANLkTimKgfKwtWpXBvTGmJbW-2uGhV+7nMahsScUM0pr@mail.gmail.com>
	<20110216155422.GA4056@dumpdata.com>
Date: Wed, 16 Feb 2011 13:51:25 -0500
Message-ID: <AANLkTimfNGXNzejS7hsk-R8HNnur9p+UwKv96AEq9vti@mail.gmail.com>
Subject: Re: [PATCH 4/5] radeon/ttm/PCIe: Use dma_addr if TTM has set it.
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, konrad@darnok.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:54 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> Code looks good but GART stuff can be picky, i will try to do a full
>> scale testing in next couple week.
>
> ping?
>

Sorry haven't time to do one. But it looks good to me.

Cheers,
Jerome
