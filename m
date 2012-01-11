Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2AKMmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:42:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37372 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2AKMmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:42:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWHgQY-=43ReEOHgDtdAFhhOELaB8aNimV99+ud1Y=NCA@mail.gmail.com>
References: <20120110003705.GA9482@kroah.com>
	<CAMuHMdWHgQY-=43ReEOHgDtdAFhhOELaB8aNimV99+ud1Y=NCA@mail.gmail.com>
Date: Wed, 11 Jan 2012 13:42:08 +0100
X-Google-Sender-Auth: IRXlR1kplEmMmUMLwvqZqz3fCUw
Message-ID: <CAMuHMdVSQS0B_DotQytbmeBs0=a4=8NMhdG5UVXbWjBXYrykFQ@mail.gmail.com>
Subject: Re: Latest kernel stable/longterm status
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 13:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Jan 10, 2012 at 01:37, Greg KH <greg@kroah.com> wrote:
>> First off, please everyone remember to mark any patch that you want to
>> have applied to the stable kernel trees with a simple:
>>        Cc: stable <stable@vger.kernel.org>
>> marking in the Signed-off-by: area.  Once the patch hits Linus's tree, I
>> will automatically be notified of it and it will be applied if possible.
>> If it does not applied, you will be notified of that.
>
> How do you want us to specify to which versions it should be applied?

Cc: v3.2, v3.1, ... <stable@vger.kernel.org>

?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
