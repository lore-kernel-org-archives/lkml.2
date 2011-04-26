Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1DZRHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:07:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59276 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1DZRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=evkCayv6IQ2YVt5B22B6mYitT1dhmv92RzTQ4Wz0sUI/M2lIAzADHudJiX4qZMby8N
         hs8gg11F3IebzaWjWBeYVqlSVS4726bR7qy0jaSbuL1ceAqUUrVBRLjrenIE/TTtTlyD
         RHtge7WSS/aCrrwVIXNsMrTplL2jW5wfWz3TU=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com>
References: <4DB4AEF7.3090607@verizon.net>
	<BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com>
Date: Wed, 27 Apr 2011 01:07:01 +0800
Message-ID: <BANLkTikFUhiDSEM_yLtbzmhfdUWBDv71ww@mail.gmail.com>
Subject: Re: [PATCH] kbuild: mark unicore32 header export as broken
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: pefoley2@verizon.net, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, mmarek@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 2:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Apr 24, 2011 at 7:15 PM, Peter Foley <pefoley2@verizon.net> wrote:
>> This patch marks userspace header export for unicore32 as broken so that
>> it is skipped when running make headers_install_all.
>>
> Why ?
>
> I would expect you to send this to arch/unicore32 maintainer too, he
> is not in the CC: list.

+1

If you see errors when install kernel headers on unicore32, fix them instead
of marking it as broken.
