Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab0LTXgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:36:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55136 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0LTXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q8g8JLCxUOXxXI7jwBotwX7WJ+LJv0lo9h71Wli3mCWpBL19jnRaIrRLS+oaAG42NJ
         ddaZMB8OpLoEDtCZiU38LNkCtEmYfQNcLLp7q+w2FGx+4bu8EvuAU4dBwkB23TSLcmYl
         ULH7AD7WaaO2hmH636CW8w1osAQ7FSR7L1s2g=
MIME-Version: 1.0
In-Reply-To: <20101220103307.GA22986@infradead.org>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<20101220103307.GA22986@infradead.org>
Date: Tue, 21 Dec 2010 08:36:01 +0900
Message-ID: <AANLkTikss0RW_xRrD_vVvfqy1rH+NC=WPUB2qKBaw5qo@mail.gmail.com>
Subject: Re: [RFC 0/5] Change page reference hanlding semantic of page cache
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 7:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> You'll need to merge all patches into one, otherwise you create really
> nasty memory leaks when bisecting between them.
>

Okay. I will resend.

Thanks for the notice, Christoph.



-- 
Kind regards,
Minchan Kim
