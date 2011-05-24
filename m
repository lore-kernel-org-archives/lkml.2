Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1EXJhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:37:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51419 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab1EXJhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dG9FGKbe+PL1+6zOlI7p2oQXXWEMKJVBc9Su0tw5sEItUoG+6k+Bx0nzccqD+tGRgq
         D3rGtGGCzs83kKLEfWqFPp25ujFBiXw9/d1objeqrQly7d16tNCZtHkGXrB8c88lg5jE
         mTRONGGEvIRCKcoaoLZb3nMYAeYSZQkUwDjPA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikaJuw9WE-87cNkh1UQPgyP3mokVg@mail.gmail.com>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
	<1301696134-31249-1-git-send-email-vapier@gentoo.org>
	<20110403234402.GC1420@mtj.dyndns.org>
	<BANLkTikaJuw9WE-87cNkh1UQPgyP3mokVg@mail.gmail.com>
Date: Tue, 24 May 2011 11:37:31 +0200
X-Google-Sender-Auth: 6Rq8dz58-wcHNjrpRlilBd_ESPw
Message-ID: <BANLkTi=6D640-Cz+e7EpFVMYd=vpeY9v+Q@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 1/2 v2] percpu: unify input section names
From: Tejun Heo <tj@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 24, 2011 at 3:46 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> i dont see this in mainline for 2.6.40-rc1 either ?

Just sent pull request.  Was waiting for more fixes and waited too long.

Thank you.

-- 
tejun
