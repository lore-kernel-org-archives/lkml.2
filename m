Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0FUHyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:54:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0FUHyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FYU/kARPQKmjiNQvSUOum4QHILDV6J2crPgSVfXMaKF++WkX7C0r9mwmNpIGGzHuRW
         uadsmLocFVoZVHqF2+SI25y6LO+Fhaq7v9Bl8Uf/MZ+hdql277coZ4etlhi8za8ghtse
         AQigBzCNxBWSnIyIYYkhb4V+9n3IgdZ2npNw8=
MIME-Version: 1.0
In-Reply-To: <1277098513.947165.104554431018.0.gpush@pororo>
References: <1277098513.947165.104554431018.0.gpush@pororo>
Date: Mon, 21 Jun 2010 09:54:01 +0200
X-Google-Sender-Auth: I3GCkoiUtocOo0gF5vEr-5-oWuk
Message-ID: <AANLkTikBESJzzQ87AzVg7ZBB3ygbWXK4aw3u0xSJSJi2@mail.gmail.com>
Subject: Re: [PATCH 0/2] Common struct clk implementation, v5
From: Linus Walleij <linus.walleij@stericsson.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/21 Jeremy Kerr <jeremy.kerr@canonical.com>:

> Comments most welcome.

I think this is a step in the right direction, if it gets merged I will switch
the U300 over to it.


Yours,
Linus Walleij
