Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab1DYMti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 08:49:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55039 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1DYMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 08:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=er5zEQtQuNo7fUUgO5OQRU45sVx7+6ioD1/Ud234UtAsip3bjleufrwKVtiIm35IHV
         CYQ92iQwffyjAdI28KwGh+OK8YYXo2FQEYX9cAp+7/y+FPqHd9PZjiK/9rw3VvYYyXU6
         BXYRbc/Nn6gQxWo4cIQDvvc6Y+mEdUvC6fSjA=
Subject: Re: Oops in 2.6.39 include/net/dst.h: dst_metrics_write_ptr()
 running l2tp over ipsec
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Held Bernhard <berny156@gmx.de>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
In-Reply-To: <4DB54450.90806@gmx.de>
References: <4DB4A619.9080600@gmx.de>
	 <1303718852.2747.103.camel@edumazet-laptop>  <4DB54450.90806@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 14:49:33 +0200
Message-ID: <1303735773.2747.122.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 25 avril 2011 à 11:52 +0200, Held Bernhard a écrit :

> Your patch works flawlessly.
> 

Well, its your patch :)

> Thanks for the quick response!

Thanks for testing.


