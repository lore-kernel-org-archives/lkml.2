Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0HPE6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:58:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65503 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0HPE6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ihcNpSJXevZernqih8aaC1BmtQETIjQ9VqUHfWcMyZV7fMklv2sk/aYzZcPQcJ8FLF
         /H7kJeDvAk1kAgfavVR+ndAkJK4+toC+y06s4SpnFPTtvmGiqYnGqF+aKKxcWQxNX2gQ
         wNENPLRhrBGAMTpVjfhTsuwws16E4RVS+adNQ=
MIME-Version: 1.0
In-Reply-To: <faf83501-1e53-459d-88ed-2ac5963a37f2@email.android.com>
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
	<AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com>
	<faf83501-1e53-459d-88ed-2ac5963a37f2@email.android.com>
Date: Mon, 16 Aug 2010 12:58:52 +0800
Message-ID: <AANLkTimtH41djAF5OxXCeVS8cHg_JCBd+wQ1iT1BUWgX@mail.gmail.com>
Subject: Re: [PATCH][EFI] Run EFI in physical mode
From: huang ying <huang.ying.caritas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, tglx@linutronix.de,
        mingo@redhat.com, vgoyal@redhat.com, nhorman@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> No, it should not be dynamic; rather we should unify all the users who need a 1:1 map and just keep that page table set around.

Agree. One known issue of global 1:1 map is that we need to make at
least part of page table PAGE_KERNEL_EXEC for EFI runtime code, and
change_page_attr can not be used before page allocator is available.

Best Regards,
Huang Ying
