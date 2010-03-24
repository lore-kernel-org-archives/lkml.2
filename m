Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0CXGEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 02:04:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:5102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0CXGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 02:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qF335nYpiZ05rN94p6z0Qb4g+zKqAO0SAq22GFqW52CgJ8V+LSATmV+KrdYml9Wenn
         pdMPcp4Th3il6RH7RLGyLxK7bzYq/MPNL9auIYXUV8zn+fhqWqgWai9ytz8KgdQzdLwC
         E+ae17YtceGrVKiUiPUEKmrFw1amPW+Cqv+ks=
Subject: Need to intercept open&write calls for vdi file when VirtualBox is
 working.
From: Sergey Malykhin <sergey.malykhin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 12:04:33 +0600
Message-ID: <1269410673.29577.1.camel@wimax-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

My problem - I have to intercept open&write function calls to .vdi file
when VirtualBox is working to control which sectors of vdi file were
changed, i.e. I need to get 1. what file was open for writing; 2. data
from buffer; 3. size of data; 4. offset in file;

I tryed: 
          - LD_PRELOAD - not helped

          - using fuse - rewrote write call and successfully
intercepted, but fuse is slow.

I have possibilities to patch ext3 or patch inotify.

Is there any better way to do it?

TIA


