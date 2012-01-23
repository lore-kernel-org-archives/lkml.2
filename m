Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2AWSYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:24:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55971 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2AWSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:24:41 -0500
MIME-Version: 1.0
X-Originating-IP: [89.139.53.79]
In-Reply-To: <20120123140355.GA19255@amd.com>
References: <20120123140355.GA19255@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 23 Jan 2012 20:24:20 +0200
Message-ID: <CAK=WgbZGY9Sxw1BhZ4SpEgf=2MdxcpGTCY5f5jM9YM950YS+bA@mail.gmail.com>
Subject: Re: OMAP and MSM IOMMU driver misbehavior
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Mon, Jan 23, 2012 at 4:03 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Please tell me when I mis-read the code, otherwise please fix this in
> your drivers so that we can get consistent behavior for IOMMU-API
> users :-)

I'm a bit tied up with some schedule I have to meet this week, but
I'll definitely take a look and make sure it is fixed.

Somehow I trust you didn't mis-read anything :)

Thanks for reporting this,
Ohad.
