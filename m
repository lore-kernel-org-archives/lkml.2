Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1GTMKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:10:13 -0400
Received: from mail.elutions.com ([64.31.159.3]:37501 "EHLO mail.elutions.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1GTMKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:10:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression in handling of unsafe UBI shutdown
Date: Wed, 20 Jul 2011 08:06:14 -0400
Message-ID: <F87D23B7E1F84E4AB52E4FA4A55F85DC026DADA7@tpamail.elutions.com>
In-Reply-To: <CACTFLAOsEZksaUXrN9KVeXHnSxtY-h8XWiYDyn_OxTLxmeWjeg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression in handling of unsafe UBI shutdown
Thread-Index: AcxG0zUEytQ9ohGtQyOoREZPQqmXHQAAW/Eg
From: "Mike Hench" <mhench@elutions.com>
To: "Daniel Mack" <zonque@gmail.com>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Adrian Hunter" <adrian.hunter@nokia.com>,
        "Sven Neumann" <s.neumann@raumfeld.com>,
        "Artem Bityutskiy" <dedekind1@gmail.com>
X-Mlf-Version: 7.2.4.3925
X-Mlf-UniqueId: o201107201045220005015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you an an ARM as well?
We run powerpc.

> Did you try to cut the power from your device in the middle of full
> operation? If would help a lot if you could try this.
My test is automated random power cycling while doing a complicated file
copy/compare operation I use for abuse testing.

Oh, forgot to mention, we are using u-boot 2010-06, not that old,
not new either.

Mike.


