Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2KMWbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:31:16 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61799 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2KMWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <20121113190123.GA32271@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
	<20121113190123.GA32271@kroah.com>
Date: Wed, 14 Nov 2012 00:31:13 +0200
X-Google-Sender-Auth: CydzturG9crzCsqznVbW1mR58oQ
Message-ID: <CAE7jHC8H1aB5ZOLC+brXKNvk-842_EUrJUOim5SV4B1h7i7r5g@mail.gmail.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + *   Device Model (class, device)
> Don't use class code in an example, it is slowly going away from the
> whole kernel.
What to use instead class_create and device_create?

Thank you.
