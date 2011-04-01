Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1DAPEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:04:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61912 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1DAPEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ggS2VfZsNkUMR2SW0mH3AaAIfIWADNV18vAMZhXXiqGONF067pebA7qf7oMCUQowu5
         dWaHfiGVANgrQoohkvloonJpg4ZH1L6WWVqS1Ce+AR8QkL3k9e08D77r126eEttJYMXF
         rhy4hFL2DHw36W6r1YCGE96ve7hI4bMWTuQTY=
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1301669776.2789.92.camel@localhost>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	 <4D948D52.4040708@grupopie.com>  <1301669776.2789.92.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 18:01:44 +0300
Message-ID: <1301670104.2789.94.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 17:56 +0300, Artem Bityutskiy wrote:
> Well, ok, I've measured how much is this "a lot". On an embedded arm
> platform this makes the kernel only 1.5% larger. 

But in absolute numbers this is 70KiB in my case, which is indeed
considerable amount. So, I agree that it makes sense to keep this as a
separate option.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

