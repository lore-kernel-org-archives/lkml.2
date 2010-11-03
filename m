Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0KCU0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:26:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61825 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KCU0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <1286890834.2670.21.camel@localhost.localdomain>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com>
	<201010121414.14486.ozan@pardus.org.tr>
	<1286888769.2670.5.camel@localhost.localdomain>
	<201010120919.11819.sgrubb@redhat.com>
	<1286890834.2670.21.camel@localhost.localdomain>
Date: Wed, 3 Nov 2010 16:26:34 -0400
Message-ID: <AANLkTi=4Tu=26ytCYvZSADtCdAbzw6U_9pxvHRfjwa7K@mail.gmail.com>
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Steve Grubb <sgrubb@redhat.com>,
        =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 9:40 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2010-10-12 at 09:19 -0400, Steve Grubb wrote:

> Before making any changes to the kernel xattr.h, I want to understand
> the reason for two xattr.h files, one in /usr/include/linux/ and the
> other in /usr/include/xattr/.  /usr/include/linux/xattr.h contains those
> elements not defined as __kernel__, while /usr/include/xattr/xattr.h
> contains that and other definitions.  Will changing the kernel xattr.h
> version change both?

I don't know what /usr/include/xattr/ is but /usr/include/linux/ is
where the kernel-headers are supposed to end up.  I'm guessing
/usr/include/xattr/ is the glibc function definitions?  (my glibc
function definitions for xattrs are in /usr/include/sys/xattr.h)

I sent a patch to export them all.  I didn't cc stable since it
clearly change more than it needs to, but we really should send
something to stable....

-Eric
