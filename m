Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0C1OC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 10:02:58 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:54508 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0C1OC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 10:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qYWOoCcREiymA1b2c8wEu3QokgWB2wKFcubER9t0xT55RuNlYLvKkF1zob6v62js6m
         /iCLHOArPrPHydVJnvpovOc6cJd9bKBWgrNVMKOfFyT01AAWE6GC8QYJHpG8gfCzZTec
         bRuaF08yMVfM3Llp0jrmRn6TLMUg1CZ4KgKHY=
Message-ID: <4BAF618E.2010604@gmail.com>
Date: Sun, 28 Mar 2010 16:02:54 +0200
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add random binaries to .gitignore
References: <4BAF4DAF.70609@gmail.com> <20100328133500.GB3622@core2> <4BAF5BD7.1060208@gmail.com> <20100328141957.GA3689@core2>
In-Reply-To: <20100328141957.GA3689@core2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 2010-03-28 16:19, Alexey Dobriyan pisze:
> On Sun, Mar 28, 2010 at 03:38:31PM +0200, Jan III Sobieski wrote:
>> W dniu 2010-03-28 15:35, Alexey Dobriyan pisze:
>>> On Sun, Mar 28, 2010 at 02:38:07PM +0200, Jan III Sobieski wrote:
>>>> +# random binary files
>>>> +Documentation/filesystems/dnotify_test
>>>> +Documentation/laptops/dslm
>>>> +Documentation/timers/hpet_example
>>>> +Documentation/vm/hugepage-mmap
>>>> +Documentation/vm/hugepage-shm
>>>> +Documentation/vm/map_hugetlb
>>>> +arch/x86/boot/compressed/vmlinux
>>>> +arch/x86/tools/test_get_len
>>>
>>> This should go to per-directory gitiignores.
>>
>> I agree that it is not the best solution. But one directory one
>> .gitignore also isn't the best, so I propose this
> 
> .gitignore in leaf directory is the status quo.
> 
> 	find . -type f -name '\.gitignore'

Ok

-- 
Jan III Sobieski

Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>

diff --git a/Documentation/filesystems/.gitignore
b/Documentation/filesystems/.gitignore
new file mode 100644
index 0000000..1ddd62a
--- /dev/null
+++ b/Documentation/filesystems/.gitignore
@@ -0,0 +1,2 @@
+dnotify_test
+
diff --git a/Documentation/laptops/.gitignore
b/Documentation/laptops/.gitignore
new file mode 100644
index 0000000..f6bb9d0
--- /dev/null
+++ b/Documentation/laptops/.gitignore
@@ -0,0 +1,2 @@
+dslm
+
diff --git a/Documentation/timers/.gitignore
b/Documentation/timers/.gitignore
new file mode 100644
index 0000000..f710cba
--- /dev/null
+++ b/Documentation/timers/.gitignore
@@ -0,0 +1,2 @@
+hpet_example
+
diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
index 09b164a..3c65a46 100644
--- a/Documentation/vm/.gitignore
+++ b/Documentation/vm/.gitignore
@@ -1,2 +1,6 @@
 page-types
 slabinfo
+hugepage-mmap
+hugepage-shm
+map_hugetlb
+
diff --git a/arch/x86/boot/compressed/.gitignore
b/arch/x86/boot/compressed/.gitignore
index 4a46fab..b71c8ca 100644
--- a/arch/x86/boot/compressed/.gitignore
+++ b/arch/x86/boot/compressed/.gitignore
@@ -1,4 +1,5 @@
 relocs
+vmlinux
 vmlinux.bin.all
 vmlinux.relocs
 vmlinux.lds
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
new file mode 100644
index 0000000..b1ac2dc
--- /dev/null
+++ b/arch/x86/tools/.gitignore
@@ -0,0 +1,2 @@
+test_get_len
+
