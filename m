Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab0FJB4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:56:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54869 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab0FJB4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=w5ZUb8nxuI6EpCxLGqzxglbUZemIej7LeGxLtNvU3YuO4rcKb4dCy15jMKDbGmZg51
         3GP2k9+mo8R646Nk6Skm3KgV/oSbqaqjFyvMjsUiHzFqdPg7vD+3ruzAG7UlxzjrE1Un
         ULEB1LW9JB+pn9hvX4EiByw3r7ftpstOmkHjg=
MIME-Version: 1.0
In-Reply-To: <20100609204257.GJ1743@mail.wantstofly.org>
References: <4c0ff6b2.0c3ddf0a.2185.2e09@mx.google.com> <20100609203720.GK7660@chipmunk> 
	<20100609203929.GL7660@chipmunk> <20100609204257.GJ1743@mail.wantstofly.org>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Thu, 10 Jun 2010 04:56:27 +0300
X-Google-Sender-Auth: 9rqY_7d7FM6lrvRv1wNSBzP7YBs
Message-ID: <AANLkTimYjHs29xfc7WpwJROXM4maAlquJb-7REo1GmFy@mail.gmail.com>
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Alexander Clouter <alex@digriz.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>
>> Better still, just make this 'if(!machine_is_openrd_base())'.
>
> That form is more error prone when someone adds the OpenRD-SuperDuper,
> though.
>

I agree, and the similar could be done in pcie initialization.

-- Dima
