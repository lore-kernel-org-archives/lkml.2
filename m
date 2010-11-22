Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0KVCRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:17:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab0KVCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tTqysy0Gx0dHOrPBx5UDqnL61Zj8jAFLMlmKfx24C97rYNeMqMOsVQpO/TYBofNtW3
         7/zlo8JlLFEsE1AadVLWuRF+aDMjEiWo3Sa2p+W/CWlAyQOmpAE+mCJESVv4+mz9Xt8M
         WGZxol5g7MN/xTLgyRTlASIBbBcvpGYFUVDNg=
MIME-Version: 1.0
In-Reply-To: <20101121180941.16d787ab.randy.dunlap@oracle.com>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
	<20101121180941.16d787ab.randy.dunlap@oracle.com>
Date: Sun, 21 Nov 2010 21:17:37 -0500
Message-ID: <AANLkTikN6d9+icvwYp8Ntsa8M_USQd5QdNN24hoK2soY@mail.gmail.com>
Subject: Re: [PATCH] Revert "kconfig: Temporarily disable dependency warnings"
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        catalin.marinas@arm.com, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 21, 2010 at 9:09 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sun, 21 Nov 2010 20:58:54 -0500 Arnaud Lacombe wrote:
>> [..]
>> Alternatively, if you don't care about the menu structure, Randy
>> proposed a one-liner.
>
> which Mauro nacked.
>
> I don't care about the menu structure, I just want to eliminate the
> warnings.
>
Yes, I know. I just wanted to raise the point "if you don't care about
the menu structure, a oneliner can do the job".

 - Arnaud
