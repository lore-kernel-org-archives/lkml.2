Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab0FOUiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:38:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55262 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0FOUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GNMx9iCynO2WU0CqpODd6TDzXEhGfZ1kgXG4NSLGlGrJf8nbJuLCW1CQJW5cQL6pVy
         FwpRdq5irlVU/Y9betfCUSO9zXNXwsHmnFx2Rp3rL0iTgZuGQ80GrpzBFlBgJLzqFAI7
         w5ioZRrkuxaR/wB3Pv9+YADwYhAgdLzrKLbEE=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.35-rc{12} regression: inactive console corrupted
Date: Tue, 15 Jun 2010 22:38:11 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20100612103321.GA1458@ucw.cz>
In-Reply-To: <20100612103321.GA1458@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006152238.12022.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 12 czerwca 2010 o 12:33:22 Pavel Machek wrote:
> Hi!
> 
> When something happens on inactive  console (using fbcon), display is
> corrupted -- lines at end of screen are not erased properly.
> 
> I see it on zaurus, but I suspect problem is generic.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16222
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
