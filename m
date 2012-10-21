Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2JUCJI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 22:09:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39943 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754175Ab2JUCJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 22:09:06 -0400
Message-ID: <1350785344.16706.6.camel@joe-AO722>
Subject: Re: [PATCH 1/2] staging: android: checkpatch.pl fixes
From: Joe Perches <joe@perches.com>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: "Ken O'Brien" <kernel@kenobrien.org>, gregkh@linuxfoundation.org,
        swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        dhowells@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 20 Oct 2012 19:09:04 -0700
In-Reply-To: <1350785121.12361.2.camel@CruzBishop-ASPIRE>
References: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <1350781512.16706.3.camel@joe-AO722>
	 <1350785121.12361.2.camel@CruzBishop-ASPIRE>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-21 at 12:05 +1000, Cruz Julian Bishop wrote:
> is there currently any way to insert, say,
> a comment that filters out the next line for checkpatch
> errors?
> 
> For example,
> 
> /* checkpatch_ignore_(rulename) */
> (Long line that can't be broken here)

Nope.  checkpatch is a stupid little tool.
It has its place, but it's a very limited one.

If you want to extend it, knock your self out...

