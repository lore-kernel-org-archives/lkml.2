Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1ASW2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:28:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47220 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab1ASW2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:28:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZYZ+tI4RLsfEq00szSQ+xeE7ZlHvwT5hJsiBjAwXJcisdw0ngP50+Pun9pj+IUBCTF
         Hm66XoBXTtvW8ZkgKZk2Ws5hobduyoFHPciBrFtjUrWaAr5DsDztMlDRBH5q+wCUQ80b
         8pi1/vBS6DjGdOosGcggM7ip1lC4HIKqOa81w=
MIME-Version: 1.0
Date: Thu, 20 Jan 2011 09:28:09 +1100
Message-ID: <AANLkTintj=37E17oc4ndEw3jWqH9+YbtZPGJ6RM5Mb9x@mail.gmail.com>
Subject: nf_conntrack acct option
From: Rob <roblinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nf_conntrack module loaded and acct option is active, but error
message still appears.
This has not been addressed in newer kernel versions, according to my googling.
acct option was to be removed in 2.6.29, according to kernel config.

Using:
Linux version 2.6.35-24-generic
Ubuntu 10.10

cat /sys/module/nf_conntrack/parameters/acct
Y

[   23.460237] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[   23.460239] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[   23.460240] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
