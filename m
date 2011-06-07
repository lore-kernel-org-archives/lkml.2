Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1FGJWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:22:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56817 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1FGJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:22:32 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <20110607075221.GB4407@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <20110606100950.GC30762@amd.com> <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
 <20110606153557.GE1953@amd.com> <BANLkTinwwVO4TmsxuTfSBf6jqYrEVV3b_A@mail.gmail.com>
 <20110606192030.GA4356@amd.com> <BANLkTinx21-E3DRe9D7LRB8e1aeOwv=-9A@mail.gmail.com>
 <20110607075221.GB4407@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 Jun 2011 12:22:11 +0300
Message-ID: <BANLkTimR3KofKA3LSKXdX8k1FGR0XUxu=Q@mail.gmail.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 10:52 AM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Yup. Btw, is there any IOMMU hardware which supports non-natural
> alignment? In this case we need to expose these requirements somehow.

Not sure there are. Let's start with natural alignment, and extend it
only if someone with additional requirements shows up.
