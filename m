Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1EBS6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:58:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1EBS57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=nlbougCrs0FKhLBXCvCGEukfSv6uStYezeH2eZiBPevhCQWmaXDxXkY38L4W0s+mLv
         8NDlB8X3l20d4/7K1OXQ==
MIME-Version: 1.0
From: Mike Waychison <mikew@google.com>
Date: Mon, 2 May 2011 11:57:35 -0700
Message-ID: <BANLkTimmr=rD84cAkQ2xGsG7PccxQKKqVg@mail.gmail.com>
Subject: linux-firmware tree
To: david.woodhouse@intel.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I'm trying to understand the purpose of the linux-firmware tree.
Forgive me if this is a stupid question, but the only information
about it I could find was your original post back in 2008:
https://lwn.net/Articles/294308/

Will the Linux kernel sources always continue to have the firmware
blobs and the linux-firmware tree is only for those users of distros
that strip the firmware out?

I'm trying to understand if there would ever be a need to integrate
the linux-firmware tree into our builds (we build a derivative of
Linus' tree).

Thanks,

Mike Waychison
