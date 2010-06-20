Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0FTGzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 02:55:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50391 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0FTGzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 02:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=h+gpl+9PTnVFE896ln5qh3xwyXiIDMZFEOlGvu5178/vsfvghEoG9Mtns4XOwQaPnR
         3Tpyudymm8lzxcLGOVaewKTGw87T685/z4lEMWeuHF0cb8UqZi9XS4q/3z8ui3TRv1VI
         LWReHf4rFRzFdN4MCNB9faOnNMKSJTGhXupwg=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
Date: Sun, 20 Jun 2010 08:55:33 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Manfred Spraul <manfred@colorfullife.com>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
In-Reply-To: <alpine.DEB.2.00.1006180940140.11575@router.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006200855.34169.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 18 czerwca 2010 o 16:49:44 Christoph Lameter wrote:
> Can produce it with make-kpkg building a kernel.
> 
> git show
> 
> commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jun 11 19:14:04 2010 -0700
> 
>     Linux 2.6.35-rc3
> 
>

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16255
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
