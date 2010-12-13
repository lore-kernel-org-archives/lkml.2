Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab0LMN4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:56:30 -0500
Received: from mxout1.idt.com ([157.165.5.25]:56525 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809Ab0LMN41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:56:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 4/4] RapidIO: Add new sysfs attributes
Date: Mon, 13 Dec 2010 05:55:22 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201665627@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20101212184834.GA17052@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 4/4] RapidIO: Add new sysfs attributes
Thread-Index: AcuaLxW48pzzTOsKTfmykEO9LOt+RgAnSJCQ
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com><1292013498-31406-5-git-send-email-alexandre.bounine@idt.com> <20101212184834.GA17052@kroah.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, "Thomas Moll" <thomas.moll@sysgo.com>,
        <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Like Andrew pointed out, all sysfs files are required to have entries
in
> Documentation/ABI.  If the existing rapidio sysfs files are not
> documented, please document them in there _before_ adding new ones.
> 
I included RapidIO documentation update into my plan for next set of
RapidIO patches. Until than this patch may be safely dropped without
affecting other patches in this set.

Alex.  
