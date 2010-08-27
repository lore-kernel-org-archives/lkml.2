Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0H0CLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:11:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54526 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0H0CLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ALcBDAjiQxEUJ0zllxgV2wS3uedelY+b4sTWabvWs6iHffPunCzTfUDAEYocYf6vMV
         +eEazmtIxI6+rFfCD39GLRVZhsoLD9kLqE4Njc1ZfYTNnDH44fh6rV6YgnyHGPkR/0UZ
         Tx4DGk85lWIZSgKvnwu9l/L5rxMSMgR6F6rAQ=
MIME-Version: 1.0
In-Reply-To: <32426.1282852938@redhat.com>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
 <20100826141115.11132.52122.stgit@warthog.procyon.org.uk> <AANLkTinxwf6kY6hCnUn=ATSYFutCAeSJQ1pgUj11UfD4@mail.gmail.com>
 <32426.1282852938@redhat.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 26 Aug 2010 22:11:27 -0400
X-Google-Sender-Auth: LKUJG9HV5m0CDvebRl7tq6ty_jc
Message-ID: <AANLkTi=QoMLTEDVfW0oKGVs-MhG+GpNxjC6axzLaHFKR@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 2/7] Blackfin: Don't redefine
 blackfin serial port symbols
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 16:02, David Howells wrote:
> Mike Frysinger wrote:
>> we've got a local patch doing pretty much the same thing, but it's
>> waiting on driver patches being applied.  so once those are all set, i
>> can push up the Blackfin one.
>
> Can you give it to me to apply to my patchset in place of this one?

this guy:
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=8e289204d2d190a8b430edf956a315ba383d85f6
-mike
