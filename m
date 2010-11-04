Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0KDS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:29:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34810 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0KDS3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=xkJDxhSy5m3B9jVKhIvRrbwiHBW9ecu3KN7rCAONHHno12TKziz+xsFd1StIE37uFy
         aYNG1NzIDOTwXTKQL77y2T0UkYiA4AQrbQpyAtfzYQTFUNF8iUD9h89weDrxkZSxEhbc
         VpIOpqB6OW51VFcyAhSJuQZjiOWntzzl8ZCEg=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Ketil Froyn <ketil@froyn.name>
Subject: Re: Kernel v2.6.36 trouble on USB disconnect
Date: Thu, 4 Nov 2010 19:29:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTik5qVxkEGVAA1PSOGk2KTW+ekHpSwttsQEWzWj+@mail.gmail.com>
In-Reply-To: <AANLkTik5qVxkEGVAA1PSOGk2KTW+ekHpSwttsQEWzWj+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011041929.40014.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 29 października 2010 o 10:05:47 Ketil Froyn wrote:
> I get the following trace when I disconnect USB devices. I'm running a
> self-compiled 2.6.36 kernel from Linus' tree. It's on a Fujitsu
> Lifebook P8110, as indicated in the trace. The system is a pretty
> fresh install of Ubuntu 10.04.1.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=22092
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
