Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1GDVzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:55:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1GDVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:55:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Date: Mon, 4 Jul 2011 23:54:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <201107042237.05295.arnd@arndb.de> <20110704225520.2d0004f3@lxorguk.ukuu.org.uk>
In-Reply-To: <20110704225520.2d0004f3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107042354.31321.arnd@arndb.de>
X-Provags-ID: V02:K0:lb2vRFbqDXoIHguQCHjJk5L7H+TCQJX4XYXJTtsgjU2
 qgDkt+mlHYYxPKX5CvbXXjgzD6oCQRS7VKyFBhFusjFAvuiSBi
 LMy4jDzULlTMjJyqhZt5/XCFi8L+Ga26wXgInBwl9/+Gcxdkqr
 4e3iXxuYTe4Jk9ZomwQXmhAUqdEcKgtksE6YdOeeQX8CnsiFlJ
 5peEvVzQlKYeWSeqijoBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 July 2011 23:55:20 Alan Cox wrote:
> > How are people using those ISA cards today? The version of setserial
> > that I found is not able to set MMIO mode on those. I suppose you
> 
> Various ugly hacks, if its tricky we can drop support and see who screams

I don't think it's much of a problem, I just didn't expect these to exit.

	Arnd
