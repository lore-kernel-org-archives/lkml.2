Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845Ab0GSRlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:41:12 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:33117 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760783Ab0GSRlL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:41:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 620193.79464.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ORQ5dZ9PzR3m2vGq04sHj0v8uXxC71XzVuNYOu+mtIoqSFcJO+cU7r9Y4MdUWi5PRNqPQvaiGRVjeCarq5Tr+bsW3qMZ9TtxHG7JdkBA60oZ+qSSMDd1OQwdaDfkAfpfEEMMpJqFeXrej/l/oSVWaIIvcaI2Xy5hPrwZcCP5JjQ=;
Message-ID: <463626.69698.qm@web180301.mail.gq1.yahoo.com>
X-YMail-OSG: oc5pj5MVM1n.m05R8TMtwzrBheuDHWRo5c51Xzfo676.rQW
 ml9xNbgg.0ulpItzvdknoWm0SrcVCG2lZEvpkDhosSesYdKiCTTqx1r9Eutp
 pu5SmfVIzXsFqbJkM9Y5xtk1_kBNAO7jooFewDINhyU9N.2LtR2_fzililoC
 cpmojFF_TYd1rhZ3lkR2.BwXjq12TO2.5BU_poXiNu7nplrrJBBJm7ugEHFT
 gUCVAlmpZD3LbaAtAA9EabiJVidUfkjYi55py2DniykbR87JeRJVA3mbqC5e
 4tT7yzGt6sNGOAhMPwxRBPj2qO7pQOIdZCVNV1tkmzxrjYYb1DYL09g--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Mon, 19 Jul 2010 10:41:10 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
To: Alan Stern <stern@rowland.harvard.edu>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
In-Reply-To: <op.vf3o6v067p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 7/19/10, Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:

> I'm not entirely sure of what the issue with
> the patches is really. It merely adds a serial
> number to the gadgets using MSF and that's all.

Go back and read what I wrote then.  The issue is
that THERE ALREADY IS SUCH A MECHANISM.  We neither
need or want another way to do it.  The answer is to
use the existing mechanism correctly.

Plus, you seem to be overlooking the basic need
(for userspace) to manage these IDs so they're
properly unique.  Two gadgets should never end up
using the same serial number.

I tire of repeating these basic points...



