Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0GLKtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:49:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47153 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab0GLKtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:49:14 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Aggarwal, Anuj" <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Date: Mon, 12 Jul 2010 16:19:03 +0530
Subject: RE: [PATCH 1/2] regulator: tps6507x: allow driver to use
 DEFDCDC{2,3}_HIGH register
Thread-Topic: [PATCH 1/2] regulator: tps6507x: allow driver to use
 DEFDCDC{2,3}_HIGH register
Thread-Index: AcshrrKbMNYEFesHQgeg+qs+Wpzs/AAAK4rg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301E7AAD278@dbde02.ent.ti.com>
References: <1278930888-26810-1-git-send-email-nsekhar@ti.com>
 <20100712104045.GE21840@rakim.wolfsonmicro.main>
In-Reply-To: <20100712104045.GE21840@rakim.wolfsonmicro.main>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mark,

On Mon, Jul 12, 2010 at 16:10:45, Mark Brown wrote:
> On Mon, Jul 12, 2010 at 04:04:46PM +0530, Sekhar Nori wrote:
>
> > +
> > +   /* Does DCDC high or the low register defines output voltage? */
> > +   bool defdcdc_high;
>
> This should probably be "defdcdc_default" or something.  Presumably the
> line can also be wired to a GPIO and changed at runtime (otherwise the
> feature seems at best odd) and if support for that is implemented then
> this will change from being a static configuration in the platform data
> to something configured dynamically so the name would no longer make
> sense.

Quite right, it should be possible to change that line at runtime - though
none of the existing boards use that flexibility. Will change the name as
you have suggested.

Thanks,
Sekhar

