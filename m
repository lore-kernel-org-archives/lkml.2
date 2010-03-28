Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0C1Nig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 09:38:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46123 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab0C1Nie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 09:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w+7/q8WbjqJ/5DP/gqJuxzD/r+eNC2Q5Wcw229MEIGr1CHG/RNdow85vL1QTNp1aiO
         acvj9h7XDfqmr98A2aXKkjznukcuZ1JANa9n+fldXux6vagB9tXSC9hKwwNEB2QX8ou9
         Sday+Q44ZQ2D40W0++TkxuANRFCU7MMng5Jqc=
Message-ID: <4BAF5BD7.1060208@gmail.com>
Date: Sun, 28 Mar 2010 15:38:31 +0200
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add random binaries to .gitignore
References: <4BAF4DAF.70609@gmail.com> <20100328133500.GB3622@core2>
In-Reply-To: <20100328133500.GB3622@core2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 2010-03-28 15:35, Alexey Dobriyan pisze:
> On Sun, Mar 28, 2010 at 02:38:07PM +0200, Jan III Sobieski wrote:
>> +# random binary files
>> +Documentation/filesystems/dnotify_test
>> +Documentation/laptops/dslm
>> +Documentation/timers/hpet_example
>> +Documentation/vm/hugepage-mmap
>> +Documentation/vm/hugepage-shm
>> +Documentation/vm/map_hugetlb
>> +arch/x86/boot/compressed/vmlinux
>> +arch/x86/tools/test_get_len
> 
> This should go to per-directory gitiignores.

I agree that it is not the best solution. But one directory one
.gitignore also isn't the best, so I propose this

-- 
Jan III Sobieski

Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>

diff --git a/Documentation/.gitignore b/Documentation/.gitignore
new file mode 100644
index 0000000..bcd907b
--- /dev/null
+++ b/Documentation/.gitignore
@@ -0,0 +1,7 @@
+filesystems/dnotify_test
+laptops/dslm
+timers/hpet_example
+vm/hugepage-mmap
+vm/hugepage-shm
+vm/map_hugetlb
+
diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
new file mode 100644
index 0000000..0280790
--- /dev/null
+++ b/arch/x86/.gitignore
@@ -0,0 +1,3 @@
+boot/compressed/vmlinux
+tools/test_get_len
+
