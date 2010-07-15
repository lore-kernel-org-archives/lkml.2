Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab0GORia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:38:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49124 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933882Ab0GORi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=hM9AVsMDRvhY9L2ALaerPP3TZH5l/3HMY6uJMg7Bb+X3VFIA+QD880+fWe/trmXhKy
         hbf8HFFuEMCZYwNdb8LE1+ubUNGe6DAAuzAPOJAmJgwAvPOn+zhsvnG1NRETv8KCqwzB
         vQWqCqJLTPsSqFJbq15jsM+50526t6QpSMiO0=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Martin Pirker <lkml.collector@gmail.com>
Subject: Re: 2.6.35-rc5 inconsistent lock state
Date: Thu, 15 Jul 2010 19:38:22 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc5; KDE/4.4.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
In-Reply-To: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007151938.23093.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 14 lipca 2010 o 22:33:10 Martin Pirker wrote:
> Hi list...
> 
> My shiny new kernel wants to tell me something.
> I do not understand him, but maybe you do.... see below
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16400
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
