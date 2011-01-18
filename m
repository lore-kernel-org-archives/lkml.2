Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1ARUd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:33:29 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47311 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1ARUd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qgX8/f1lC0yniNMThx0IWo6q3BJbz5DzTBw59XLxEGXlqGUixljbnhaX7/f12462DS
         TWhkvv4wuUfdt1Noe+wMMhaaIwi88HOFYxqPNPd4i6WelLVufGdt73EkLoF9rq3RZ2JT
         5BnTbikMFhfXO2AyYsFdakks8SA51NWC17vEE=
Subject: Re: WARNING in module rt2870sta stable kernel 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Giangiacomo Mariotti <gg.mariotti@gmail.com>, Greg KH <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTi=-4k0hbM9gESLBfzJW_reonqX_GMiVzXzRJFqu@mail.gmail.com>
References: <AANLkTi=HsE+h9GU8rM6zW2BVtoayEGfKOmPCsrrNHiz5@mail.gmail.com>
	 <AANLkTi=-4k0hbM9gESLBfzJW_reonqX_GMiVzXzRJFqu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 21:33:23 +0100
Message-ID: <1295382803.3194.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 janvier 2011 à 23:25 +0300, Denis Kirjanov a écrit :
> I have sent a patch to fix this problem: https://lkml.org/lkml/2011/1/10/329
> It also fixes a bug #26472: https://bugzilla.kernel.org/show_bug.cgi?id=26472

OK, next time CC netdev so that we can Ack your patches ;)



