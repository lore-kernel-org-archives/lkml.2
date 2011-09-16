Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1IPJ5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:57:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1IPJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:57:31 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.183.149]
In-Reply-To: <20110915104524.GY11701@amd.com>
References: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbCgXjOQ=xXSwnVhT9sqsYtpo6cFcRQYSEGY2ow215n=Q@mail.gmail.com> <20110915104524.GY11701@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 16 Sep 2011 12:57:08 +0300
Message-ID: <CAK=WgbbqJKdm+=s-+Zmv9b7aoWeB2-14W70RXhVCQGJPaUzJKw@mail.gmail.com>
Subject: Re: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 1:45 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> This doesn't work on platforms that may have more than one possible
> iommu driver, like x86 for example.

Ok.

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

(cc'ing Laurent for the VIDEO_OMAP3 part)
