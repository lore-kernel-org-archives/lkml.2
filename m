Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0FNOiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:38:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62461 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0FNOiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kVekZygw0JGeYO+j/ynJZtXXG1bubcnXlLqQpPuW7bA79YcX70YwQxXJpggKXyNHrA
         +gGJs9F0WaM1UFU+tMgNyMKuhL0FiIT09kB2k4O9P8pIHpIPoS8yXO3BygPL606PwcRI
         Mxkn6WjyYMBdZCfI2PxGT7QBteV8ijlYG13XI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Ales Teska <ales.teska@gmail.com>
Subject: Re: PROBLEM: PPP and other serial port related application hangs in kernel space
Date: Mon, 14 Jun 2010 16:38:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc3; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
In-Reply-To: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006141638.10734.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 9 czerwca 2010 o 22:46:28 Ales Teska wrote:
> Hi all,
> 
> after upgrade of Linux kernel to version 2.6.34 I started to observe
>  following problem - ppp and other serial port related application
>  occasionally (in 1 hour or 1/10 ppp connections) 'hangs' (see description
>  bellow) rendering related serial device unusable. I backtracked this issue
>  to 2.6.32.15. Application remains in the condition marked as 'D' in 'ps'
>  output (waiting for result from kernel space, if I understand that
>  correctly); it stays in this condition forever. Moreover any other
>  application that tries to open same serial port hangs the same way.
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16206
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
