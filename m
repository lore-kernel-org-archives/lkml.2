Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0CaGf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:35:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61161 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0CaGfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ae4/L+3fTyJ8AIGdYiE8eN6y8dhimFswKDdNb0FgES1gEtfd3qO1GLsoqN1aqIqqV5
         nPv4iuChKzSizwIpE2CLgZdvRG5JIF4gy8uuEkvON9yR1uCYcNNA7FRx2fvh5oi9PhSg
         TepJaX/vd3VqvzxOq994MPWQreNvuaICjVeJ8=
MIME-Version: 1.0
In-Reply-To: <1269955969-26123-1-git-send-email-wferi@niif.hu>
References: <87mxxxltk6.fsf@tac.ki.iif.hu>
	 <1269955969-26123-1-git-send-email-wferi@niif.hu>
Date: Wed, 31 Mar 2010 08:35:49 +0200
Message-ID: <k2u2ea1731b1003302335s84cf9757t8127050d242710f6@mail.gmail.com>
Subject: Re: [PATCH 0/3] RFC: direct MTD support for SquashFS
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Phillip Lougher <phillip.lougher@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/30 Ferenc Wagner <wferi@niif.hu>:
>
> Extra question: does squashfs_put_super require BKL protection?
>

We should get rid off of BKL, so if you need a lock, you should use a
local mutex.

Marco
