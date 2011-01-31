Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1AaREM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:04:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41554 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab1AaREK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cjwizbxTdRLA+Eb9nXxh9F8oq2Q3n0N2oUcjqMJUunIB0qpY9zVTaLXUUU4AlbnutC
         zhM6UQDxLkRLpN1zrt0uAdaoLVJ3gYKybWXSzXgH6vxBSl0O+IlwCJuuH0J5DJ3s+d6T
         PlJqQrr5ugqi269bKXAfufVO0Of2plSxKZE0E=
MIME-Version: 1.0
In-Reply-To: <1296493175.26427.37.camel@moss-pluto>
References: <AANLkTi=4CH2zFrDp6DAnSj3pa28MtymfG+NrtQ3iW5k-@mail.gmail.com>
 <1296482354.26427.21.camel@moss-pluto> <AANLkTimt5sxmgUmn-i-WcgMN4d0X00YVMujsA4QgS8nX@mail.gmail.com>
 <1296493175.26427.37.camel@moss-pluto>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 31 Jan 2011 19:03:49 +0200
Message-ID: <AANLkTi=3z-en0HAgVx1hRKrj6KYOHi_ZUP4aDv=8zUaa@mail.gmail.com>
Subject: Re: [PATCH 2/2] RFC: selinux: sysctl: fix selinux labeling broken by
 last patch
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux <selinux@tycho.nsa.gov>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 6:59 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> /proc/sys inode labeling was disabled earlier (hence marked S_PRIVATE)
> when /proc/sys was reimplemented by Eric, so all access control
> on /proc/sys was switched to using the sysctl hook rather than the
> inode-based checking.  That's why you don't get a result from ls -Z
> on /proc/sys on current kernels.  Getting actual labeling working again
> for those inodes would be a win, so your patch is an improvement in that
> regard for selinux.


Oh, OK. Thanks for letting me know.

Do you see anything else that is wrong with these patches (apart from
"//deleted")?

-- 
 .
..: Lucian
