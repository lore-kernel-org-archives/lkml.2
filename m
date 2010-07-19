Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462Ab0GSKJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 06:09:37 -0400
Received: from n10.bullet.mail.ac4.yahoo.com ([76.13.13.238]:39501 "HELO
	n10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760451Ab0GSKJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 06:09:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 685430.93282.bm@omp125.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xxuNX1YO3RdU65OAHmXovQ6l94nSb1XjGVBCPG+pBNDfpnoVQEMHaUkudIXw1KTKJdsExa58/hEVLsZEhlQZg3OsK0RTui78F68J+CbFqaGQSh94IH20dGv4CQsg2fDSZKzZxxRlzFQILjWtJbkxc+Z4ATcPbSB0JNdi+ZDAnpE=;
Message-ID: <590491.14987.qm@web180309.mail.gq1.yahoo.com>
X-YMail-OSG: j9UJNAUVM1mgNJ7cbIfnC3RVbftAnPzvPMAEkT24qIDz5Wy
 FcM79Pau3__RepC_aY3sSHwrTNxoqb5hba_z8QKQ8TkiKA_NVDb2EQ2JWkjN
 eGZ6sb25c8Y04uoTlHUoakjoIWdZQvtWuyvGr_rd7aGjnMXfXEQZyTZ31XrM
 AXDeAS8pbbE8jrkMyHw6EgwBX_lOfgVg7KXsuZa53yNQfAUUwGer_N.ZGNyW
 GafqIfHH9FbO8Unv76twNfoKHWXJXLOzG5OFkgS5LVj37laAsM9BlnvrHUZ1
 NRonNtHqRYNuDdqLkrUV1ejxqMK3XCQy5HkG9ED3tSBIo3GfJCS81bA--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Mon, 19 Jul 2010 03:08:36 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
To: Greg KH <greg@kroah.com>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
In-Reply-To: <op.vf21vchq7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   It in no way duplicates functionality of
> the composite layer.

Beyond the obvious "Set serial number" ...


> As a matter of fact, without
> this patch, the
> iSerialNumber module parameter won't work

So submit a bugfix for that alone, making it
work everywhere... 

> (not tested, just looked at the code).

Do you know when it broke?  That code has been
tested in the past, and observed to work.  So if
it's not working now, someone broke it and that
should just be fixed.



> The second patch (by Yann Cantin) adds a serial module
> parameter to
> the File Storage Gadget.  FSG is not a composite
> gadget 

OK, so it should add a module param with the same
name as used elsewhere ... makes sense to me.  If
Alan Acks that patch, go for it.

- Dave


