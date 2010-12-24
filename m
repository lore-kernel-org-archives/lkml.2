Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0LXMP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:15:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33724 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0LXMP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:15:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lKYqD3BHnqb3hu9TcyBGkxlBF/HkVsBUXgJxDlYix8GbqOyosw2iUUqNLi443RHUTJ
         AY/sEFGZgANIz8pynC6B5H4UKzUVm0jvtGHt8XHhunQhm9MPl6/9Ci1W7ryD1zoler31
         cB2ej5RAX8xLCV5I70dWru2WbYaa5xZAMvjek=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
Date: Fri, 24 Dec 2010 13:15:26 +0100
Message-ID: <AANLkTinegsqmSzXqqrF930abQfOBu6_MH1EToupKV214@mail.gmail.com>
Subject: Re: mmotm 2010-12-23-16-58 uploaded
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 1:58 AM,  <akpm@linux-foundation.org> wrote:
> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
>
>   http://userweb.kernel.org/~akpm/mmotm/
>
> and will soon be available at
>
>   git://zen-kernel.org/kernel/mmotm.git
>

The readme in [1] lists a wrong browseable GIT-repo URL:

"Alternatively, these patches are available in a git repository at

git:	git://zen-kernel.org/kernel/mmotm.git
gitweb:	http://git.zen-kernel.org/?p=kernel/mmotm.git;a=summary"

Correct would be [2]:

gitweb: http://git.zen-kernel.org/mmotm/

> It contains the following patches against 2.6.37-rc7:
>
[...]
> linux-next-git-rejects.patch

Hm, the content of this patch looks a bit strange.
Is that a post-cleanup patch to linux-next merge?

- Sedat -

[1] http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt
[2] http://git.zen-kernel.org/mmotm/
