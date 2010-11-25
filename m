Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0KYKTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:19:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53299 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0KYKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:19:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=J09v4DcHhkDky+H+rFaIE14XJ/e3OjNX+CGHZS9/Jee93gk/ry5hOxDk9SRrF1D1rW
         uFOUgcjFVVjHkGSgvso6GxuWfkuYK9nzssVtp6aW+P4cxBgg9rJClVDsKTLhFcYihZ2C
         gZGwT8haOo8yVbhXfAU5ohmL/DBicB4lMG9i8=
MIME-Version: 1.0
From: David Nicol <davidnicol@gmail.com>
Date: Thu, 25 Nov 2010 04:19:17 -0600
Message-ID: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
Subject: VFS support for fast copy on deduplicating FSes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unresearched question/suggestion:

Is there general support for a "fast copy" ioctl in the VFS layer,
which would be hooked by file systems that support COW or other forms
of deduplication and can provide copy semantics by manipulating
metadata only?

-- 
"It is merely a matter of persistence." -- Albert Camus
