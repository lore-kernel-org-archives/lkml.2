Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1DVJ7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:59:12 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43873 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1DVJ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:59:09 -0400
From: Richard Weinberger <richard@nod.at>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] um: Adjust current_thread_info() for gcc-4.6
Date: Fri, 22 Apr 2011 11:58:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
References: <20110422001050.GA468@shutemov.name>
In-Reply-To: <20110422001050.GA468@shutemov.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104221158.42985.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 22 April 2011, 02:10:50 schrieb Kirill A. Shutemov:
> Also reproducible with gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4).

Interesting.
Using gcc 4.5.1 it's not reproducible.
So I've to rewrite the commit message.

Thanks,
//richard
