Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab0FPT1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:27:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38223 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab0FPT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OtkxhmKL84gxIvebfUw8fNPbFNIpStIUj1ecgBI7yn0wBqvHBhG3Fg/cFgdb34M+oX
         oZNZ2iXa4Xk06zJU6mi8tZaSs4aDDzx4po5BdrJY0D841wl/A3/WgPhsLI+oPd8h/qUE
         SOWh0VD2WfGusY4EgYg7ZSlQ2K0oA2a4ysnfk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Marin Mitov <mitov@issp.bas.bg>
Subject: Re: [REGRESSION]linux-2.6.35-rc3 in net/core/dev.c
Date: Wed, 16 Jun 2010 21:27:03 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <201006131625.55481.mitov@issp.bas.bg>
In-Reply-To: <201006131625.55481.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006162127.03412.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 13 czerwca 2010 o 15:25:54 Marin Mitov wrote:
> Hi all,
> 
> I am using ssh with port redirection to log on host_at_work:
> 
> ssh -L20110:mail:110 host_at_work
> 
> With linux-2.6.35-rc3, when I telnet to localhost I get:
> 
> telnet localhost 20110
> Trying 127.0.0.1...
> telnet: connect to address 127.0.0.1: Connection timed out
> 
> but the connection at host_at_work stays ESTABLISHED
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16229
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
