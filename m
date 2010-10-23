Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0JWKcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 06:32:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42385 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0JWKcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 06:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hPMSg4yYRrm1AjoxUZgLyQsboQ6VwyR5P+w0OmowR7gynO8oOl4IXmkiC5BZ6plP0A
         7V16zef92G5cdIDFfWY2yDjt0U9CRcxLZ3u6brIxrxR4e6FO2fjTJDTS7mmqYy8K9Bwh
         k2H2zF4ot7qSuL/d21RuPAcJpUJHHjjEZkcvc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=XW2dgbi5trX7Kvoj_1L_CveLk2E-FC37NDM7W@mail.gmail.com>
References: <AANLkTi=XW2dgbi5trX7Kvoj_1L_CveLk2E-FC37NDM7W@mail.gmail.com>
Date: Sat, 23 Oct 2010 12:32:31 +0200
Message-ID: <AANLkTikqJGpVZLoReAWCrunpFPxgLjDW+uPAm_y6a5io@mail.gmail.com>
Subject: Re: linux-2.6 GIT not accessible?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 12:15 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Known problem?
>
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> Cloning into linux-2.6...
> fatal: The remote end hung up unexpectedly
>
> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Same problem here. :-(

-- 
Thanks,
//richard
