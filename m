Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0LID1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:27:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35237 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0LID1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LqYJLhi/uIpP+dPXY9YhwOfBmpuKEZfcq58QbNYot5OpXWvemgutztJFYrHLaYM09W
         kU/9V/5ZfYmTAE8pNZRYFx+okdA7snOc9CNN/go0QjVe2T+nwAGs7KPFvMl9s242Wv1X
         X+gCRGqRmf6nEf8D1prlLGP2rbq5BHzuNbjlY=
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291865039.2795.46.camel@edumazet-laptop>
References: <1291863926.2965.1.camel@Dan>
	 <1291865039.2795.46.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 04:26:58 +0100
Message-ID: <1291865218.2795.48.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 décembre 2010 à 04:23 +0100, Eric Dumazet a écrit :

> Thanks for not giving credits to people suggesting this idea to you
> (Thomas if I remember well), and not Ccing netdev where original
> discussion took place. 

Yes, credits should be given to Thomas Graf

http://www.spinics.net/lists/netdev/msg146606.html

Thanks


