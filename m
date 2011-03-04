Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab1CDM4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:56:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506Ab1CDM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:56:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, v8 1/3] hrtimer: introduce effective timer slack
Date: Fri, 4 Mar 2011 13:55:21 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name> <201103031732.28964.arnd@arndb.de> <20110304122035.GB14933@shutemov.name>
In-Reply-To: <20110304122035.GB14933@shutemov.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041355.21740.arnd@arndb.de>
X-Provags-ID: V02:K0:0ji2WyF3ii5Gplmi76/Qc7IRua1loetvSfkf5YtqB62
 BL8RHLT4bYmL3ZPBt3mFlMs2XuSMYW/XhKVvHcqwYHvNGxXQU4
 bJqc+QrBXwC7QrD0U3yEOGGHp0aWd4NOj4fdtxQgbVIQKJNZg2
 0SnfwLlL4a2nwtqTkDe8wPGwlPj9VAZSNlnOsotColx8S5ieVf
 h1C46aTokIrBRvMlHcBWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011, Kirill A. Shutemov wrote:
> > Does this make sense to you?
> 
> Hm.. I think we can add this kind of functionality to timer slack cgroup
> as a policy/stratagy later. I want to integrate basic functionality to
> kernel first.

Yes, makes sense. I wasn't objecting the current patch set, just trying
to make sure that the other idea does not get lost, and we don't introduce
anything now that prevents us from doing it later.

	Arnd
