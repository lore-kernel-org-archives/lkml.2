Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1B1V5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:57:30 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:46372 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1B1V53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:57:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=FiejEbqkK+o/ZRGln2ZtETlhKz7TpTW2ZmtjGI+eu8bNWeEY0nuaes2nIXQ4daSANZ
         R3V0g49RDUTt9KZIRFZPL2UZv1o/q9mJxDUqM6rRdOovYtDyCLqN7AyuLrKQmHc+U2iz
         y2ql4iofotgyEVJht2jCdhe3smmqpP6vMRORA=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.38-rc6: SysRq broken?
Date: Mon, 28 Feb 2011 13:57:21 -0800
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc6+; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110228214054.GA18538@p183.telecom.by>
In-Reply-To: <20110228214054.GA18538@p183.telecom.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281357.21747.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 28, 2011 01:40:54 pm Alexey Dobriyan wrote:
> It just strikes me that SysRq is broken here:
> Alt+SysRq+h doesn't print anything
> 
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_INPUT_EVDEV=y
> kernel.sysrq=1
> echo h >/proc/sysrq-trigger works
> 
> Keyboard is USB one, "Logitech HID compliant keyboard".

What does /proc/bus/input/devices show?

-- 
Dmitry
