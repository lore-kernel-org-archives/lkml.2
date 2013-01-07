Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3AGU4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:56:42 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60946 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3AGU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:56:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130107155925.GC30947@shiny>
References: <CAKaWdxYi_RpjSAp9sL9oeM2i1sCR5foKpvV2bCHDrbM0Dj3DtA@mail.gmail.com>
	<50EAEDF0.4010609@redhat.com>
	<20130107155925.GC30947@shiny>
Date: Tue, 8 Jan 2013 09:56:40 +1300
Message-ID: <CAKaWdxY97EPg8CXXWgW_69qNi1jbhVDUB-B7Cn6+9MhyS=HyXg@mail.gmail.com>
Subject: Re: data=guarded mode in ext3
From: Keith Chew <keith.chew@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>, Ric Wheeler <rwheeler@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris

>
> Ric has it right, the change was big enough that I didn't think it was
> worth the risk of changing how ext3 works.  Most people are going to
> want ext4 anyway for a lot of reasons, so it made sense to focus bigger
> changes in the ext4 code base.
>

Thank you very much for your reply. I was just asking because I was
interested in helping out in the testing of the patch.

Thanks again.

Regards
Keith
