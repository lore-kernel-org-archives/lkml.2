Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1L3OHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 09:07:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60596 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1L3OHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 09:07:35 -0500
MIME-Version: 1.0
In-Reply-To: <4EFD92AF.7000402@suse.cz>
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
 <4EFC9872.7000708@suse.cz> <CAMOw1v6GhA+B2oXcVK4YZULb6kq=-NFTv-=-4eYB0ukZ9acP-w@mail.gmail.com>
 <4EFD92AF.7000402@suse.cz>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 30 Dec 2011 12:07:14 -0200
Message-ID: <CAMOw1v4SCpOXuGmFXGfk01gRdzgvV0G0QR-wmJHRbd3XHpVFMg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 8:30 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 29.12.2011 18:35, Lucas De Marchi wrote:
>> The operation that is used most of the time is to load modules. The
>> reason for having modules gzipped is the same one as for kernel image:
>
> The reason for having the kernel compressed is that the x86 bootloader
> reads the kernel (and initrd) using bios calls. That's not the case for
> modules.

It could be when it was added, but it's not anymore.


Really, I wouldn't like the discussion to be whether having compressed
modules is good or not, but rather if it's good to have a install rule
that does all the things the right way and only once, given people
*are using* compressed modules.

Lucas De Marchi
