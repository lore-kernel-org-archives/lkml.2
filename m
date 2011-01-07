Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1AGNZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:25:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44466 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1AGNZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H3uvZHeIQosylCNhhCiJaeOI7OkG1LjRELjJaqRyteqeOFEAlMQdyqynNeVHLPb5gf
         J7idIdSuadlBDK65w1J4rgu93zj9IXxJu5rL0glXS7D8MdGz0kGOpgnYDSAKwoyIXMkx
         LTk/wqmalV/mRk1/6/onuoZDA/noAdWr+lm74=
Subject: Re: [058/152] tcp: protect sysctl_tcp_cookie_size reads
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4D270F85.9070705@gmail.com>
References: <20110106002302.141581701@clark.site>
	 <4D2691D4.3060304@gmail.com> <1294389025.2704.95.camel@edumazet-laptop>
	 <4D270F85.9070705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 14:25:43 +0100
Message-ID: <1294406743.3306.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 07 janvier 2011 à 08:05 -0500, William Allen Simpson a
écrit :

> Your helpful comments are/were appreciated.

You are very welcome.


