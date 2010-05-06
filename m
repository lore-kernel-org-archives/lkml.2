Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0EFDvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 23:51:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37104 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0EFDvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 23:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gXoVhkyLbhBw/+mFP05TVG27CLpk3ATTj65gLhGlxA87sxQx9+OZq0rlDwBYWJmcIn
         X86Wt6z0MzjUPfbxUcnKqGguzYa7rmiMETnLF5d+Qti+U5sg/ifx209bt0mhEbufHBi0
         Bx9IuBDTGJyThuGm/vleE2Iym/v+YAQo4vJMw=
MIME-Version: 1.0
Date: Wed, 5 May 2010 23:51:40 -0400
Message-ID: <w2s7fcc02551005052051s7c1810c1kad9cc44f3fb3ff5d@mail.gmail.com>
Subject: Git Bad Object
From: Tammy <tammy000@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at the commits in
http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.14. Seems
all the commits are not in the current git.

For example, if I run 'git show
0b7da0500bbf612fc532358c90aad4497309d61a', I got 'fatal: bad object
0b7da0500bbf612fc532358c90aad4497309d61a'. Why is this the case? I
thought all these commits are committed into the git repository. Thank
you!

Thanks,
Tammy
