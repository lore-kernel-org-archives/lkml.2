Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0HIOqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:46:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0HIOqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MrB6c7htUSHGegBk6rGnY9/AOFGy4MU41xvuXXM5/c0mJixt5Jx7EDZ/qEw6Ne72WX
         DXeLP0JsQ7cBgwRnRJNJFcdEuMnLYpXBGREo4y4wHgzL+53ZLFrzpL67jx1/pE05ZF1r
         gw53m78QO63IHDjci0hBs085oaRa97rQnG9dw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: 2.6.35: suspicious rcu_dereference_check() usage
Date: Mon, 9 Aug 2010 16:46:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4C594740.1090608@vlnb.net>
In-Reply-To: <4C594740.1090608@vlnb.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008091646.40611.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 4 sierpnia 2010 o 12:56:00 Vladislav Bolkhovitin wrote:
> Hello,
> 
> Today I gave a first try to 2.6.35 and it immediately produced:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16549
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
