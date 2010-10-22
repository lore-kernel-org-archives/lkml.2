Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0JVH5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:57:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36623 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0JVH47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=emR0jtXlykO8lvoChm2Au5ft4ODqM07oLCBuFIvZqhSc2AiCsvCoo3dWeXN9OyWk79
         TWGVPqiiV2ApXAV621Qgeagxa3sSw5eXD8R53KzInVDYPyZ2lHvpwHEaPmpTVHN/v53R
         +/SNq546gbjBmLYSj8Rj3GameWQ227x3K04ZM=
MIME-Version: 1.0
In-Reply-To: <AECEA79F-28E8-49B0-8C13-2CF115A6ECB4@dilger.ca>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
	<1287672077-5797-21-git-send-email-akinobu.mita@gmail.com>
	<AECEA79F-28E8-49B0-8C13-2CF115A6ECB4@dilger.ca>
Date: Fri, 22 Oct 2010 16:56:58 +0900
Message-ID: <AANLkTi=DqhFAXx3yH_NkX=Rp1ntY8X-aUv4UG61QBfRQ@mail.gmail.com>
Subject: Re: [PATCH v2 20/22] bitops: remove ext2 non-atomic bitops from asm/bitops.h
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/22 Andreas Dilger <adilger@dilger.ca>:
> On 2010-10-21, at 08:41, Akinobu Mita wrote:
>> As the result of conversions, there are no users of ext2 non-atomic bit
>> operations except for ext2 file system itself.  Now we can put them
>> into architecture independent code in ext2 file system, and remove
>> from asm/bitops.h for all architectures.
>
> Presumably there will be a separate patch series to remove the atomic ext2 bitops?  I was going to suggest removing the ext2 comment in bitops.h, but I notice that there are still the atomic bitops left.

I wanted to remove them altogether, but it turns out that I need
more consideration (what is the better name? where should they move to?)
and I have already touched more files than I expected in this patch series.
So I decided to make it a pending question.
