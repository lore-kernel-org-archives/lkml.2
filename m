Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0JLLTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:19:10 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:40761 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0JLLTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:19:08 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 07:19:08 EDT
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: James Morris <jmorris@namei.org>
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
Date: Tue, 12 Oct 2010 14:14:14 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.31.13-131-pae; KDE/4.4.5; i686; ; )
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.1007021015490.2400@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1007021015490.2400@tundra.namei.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010121414.14486.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cuma 02 Temmuz 2010 günü (saat 03:16:01) James Morris şunları yazmıştı:
> On Thu, 1 Jul 2010, Mimi Zohar wrote:
> > Make the security extended attributes names global. Updated to move
> > the remaining Smack xattrs.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > Acked-by: Serge Hallyn <serue@us.ibm.com>
> 

This drops 

#define XATTR_CAPS_SUFFIX "capability"
#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX

definitions from capability.h and puts them in xattr.h's #ifdef __KERNEL__ 
section making them invisible to userspace like libcap-ng causing build 
failures.

Am I wrong?


---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
