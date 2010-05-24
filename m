Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0EXSOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:14:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58671 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab0EXSOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hzVnaXN2JMQ2MLQOkHtNZeWeNQGFRFI36aHPCSFJhMzUiv3yoceNWRyTg/FzbEdBmW
         xRFNVzOVPZo/4pIQNJjvm3awA5F2yMixAmSI4RVmBRrwkkVZ/O96DHYqRgoYXcuATFVu
         I5mS7qWpU1XqZ2igu4+iZ/88b7jmsJOxrBeRE=
MIME-Version: 1.0
In-Reply-To: <1274150525-2738-1-git-send-email-justinmattock@gmail.com>
References: <1274150525-2738-1-git-send-email-justinmattock@gmail.com>
Date: Mon, 24 May 2010 11:14:01 -0700
Message-ID: <AANLkTilrQZFe07KprlbFeazkfbqzZQXCcvRlCJNb1B6-@mail.gmail.com>
Subject: Re: [PATCH]mm:highmem.h remove obsolete memclear_highpage_flush() 
	call.
From: Justin Mattock <justinmattock@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 7:42 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> memclear_highpage_flush has been changed over to
> zero_user_page for some time now. I think it's
> safe to say it's o.k. to remove all of it.
> (but correct me if I'm wrong).
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
>
> ---
>  include/linux/highmem.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 74152c0..c77f913 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -173,12 +173,6 @@ static inline void zero_user(struct page *page,
>        zero_user_segments(page, start, start + size, 0, 0);
>  }
>
> -static inline void __deprecated memclear_highpage_flush(struct page *page,
> -                       unsigned int offset, unsigned int size)
> -{
> -       zero_user(page, offset, size);
> -}
> -
>  #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
>
>  static inline void copy_user_highpage(struct page *to, struct page *from,
> --
> 1.6.5.2.180.gc5b3e
>
>

no response on this yet..
is it safe to say this can go in
my reject pile?

-- 
Justin P. Mattock
