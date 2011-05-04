Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1EDIG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:06:59 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36990 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751788Ab1EDIGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:06:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] atomic: add *_dec_not_zero
Date: Wed, 4 May 2011 09:05:53 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD0D@saturn3.aculab.com>
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atomic: add *_dec_not_zero
Thread-Index: AcwJ3EAltH6AZTKdQ3qO9QnukRcgpAAVa6Mw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Sven Eckelmann" <sven@narfation.org>, <linux-kernel@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-m32r@ml.linux-m32r.org>, <linux-ia64@vger.kernel.org>,
        <linux-parisc@vger.kernel.org>, <linux-cris-kernel@axis.com>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <x86@kernel.org>, "Chris Metcalf" <cmetcalf@tilera.com>,
        "David Howells" <dhowells@redhat.com>, <linux-m68k@vger.kernel.org>,
        <linux-am33-list@redhat.com>, <linux-alpha@vger.kernel.org>,
        <sparclinux@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.

Isn't there a place where a default definition of this can be
defined? Instead of adding it separately to every architecture.

	David


