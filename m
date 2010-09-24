Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0IXTbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:31:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51582 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab0IXTbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TghoOOGXG/V5uQMP1oPrsytWSTrLh69IMVnIUUdhMS+GblOfP3uf5ioXUqkvV74g6w
         lGmOy/MROSkdIjac1tnZI4KhGOQCU1n/FOLwJsD8jj7okqWennB2qYYbLRZf1mRPK/ml
         qZmH1iT46Jp6Aw5vX3S+AjVfqdx5knW81ZJf0=
MIME-Version: 1.0
In-Reply-To: <AANLkTikqf4rn6BP2gyQAuQrvt7EdFY8yfa+o8nfR9xWE@mail.gmail.com>
References: <AANLkTikqf4rn6BP2gyQAuQrvt7EdFY8yfa+o8nfR9xWE@mail.gmail.com>
Date: Fri, 24 Sep 2010 12:31:13 -0700
Message-ID: <AANLkTikvGGz+33ni=Kov1qM1DpSj2WVuk89u=TwE9iL_@mail.gmail.com>
Subject: Re: [PATCH 00/21] Staging: cleaned up makefiles cflag lines
From: matt mooney <mfmooney@gmail.com>
To: T Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 11:25 AM, T Dent <tdent48227@gmail.com> wrote:
> I changed every makefile in the staging directory to use the proper
> ccflags-y option instead of EXTRA_CFLAGS. It builds also :) .

Um, you didn't do a lot of these right. Maybe you should look into why
the change was made in the first place. For semantic reasons, I was
also changing the first assignment to ":=" from "+=".

Thanks,
mfm

-- 
GPG-Key: 9AFE00EA
