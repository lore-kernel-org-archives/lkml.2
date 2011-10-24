Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab1JXSRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:17:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab1JXSRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <20111017125126.GB18822@gere.osrc.amd.com>
References: <4E9BE18B.5070803@f-secure.com>
	<CAANzHtS8kCTBkHUwxN_s9ZucrkXHyUvzFzAN7TA7K_XGgiKwxA@mail.gmail.com>
	<20111017125126.GB18822@gere.osrc.amd.com>
Date: Mon, 24 Oct 2011 14:17:53 -0400
Message-ID: <CAANzHtRdA2EzE7qxw+nkzQZojEt7vkux5RAnBsPgUuNLZuyCKQ@mail.gmail.com>
Subject: Re: finger service @ftp.kernel.org
From: =?UTF-8?B?wqA=?= <porpen@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tarkan Erimer <tarkan.erimer@f-secure.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2011 08:51, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Oct 17, 2011 at 05:03:07AM -0400,   wrote:
>> The finger_banner page appears to be current,
>
> It doesn't look like it here:
>
> $ curl http://kernel.org/kdist/finger_banner
> ...
> The latest snapshot 3 version of the Linux kernel is:         3.1-rc4-git2
> The latest mainline 3 version of the Linux kernel is:         3.1-rc4
> ...
> $ date
> Mon Oct 17 14:50:59 CEST 2011
> ...
> Boris.

It seems both the finger_banner file and http://kernel.org home page
both list -rc4 as the current 'mainline'.
So, the rebuild of kernel.org has not yet hit the scripts that update
those files.

Give it time, those sysadmins have been rather busy lately.

Cheers!
-porpen
