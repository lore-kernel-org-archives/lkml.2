Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2KMXCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:02:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36073 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2KMXCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:02:41 -0500
Date: Tue, 13 Nov 2012 15:02:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@makelinux.com>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Subject: Re: [PATCH] LDT - Linux Driver Template
Message-ID: <20121113230236.GA25569@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
 <20121113190123.GA32271@kroah.com>
 <CAE7jHC8H1aB5ZOLC+brXKNvk-842_EUrJUOim5SV4B1h7i7r5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7jHC8H1aB5ZOLC+brXKNvk-842_EUrJUOim5SV4B1h7i7r5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 12:31:13AM +0200, Constantine Shulyupin wrote:
> >> + *   Device Model (class, device)
> > Don't use class code in an example, it is slowly going away from the
> > whole kernel.
> What to use instead class_create and device_create?

What are you trying to do?
