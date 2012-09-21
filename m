Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2IUNPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:15:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2IUNPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:15:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] ARM: add finit_module syscall to ARM
Date: Fri, 21 Sep 2012 13:15:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <1348179300-11653-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1348179300-11653-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211315.06668.arnd@arndb.de>
X-Provags-ID: V02:K0:ajSuL6DOWyfSLnWiv/A8fvv7kw4FnZVHhQBLcuJDQ81
 IK2pOEcI4c1b7wMHazrr4cRKVcBWbEzvoeczRjTSqecUQnawRz
 cGgCXKBe97OBt3xP+nk5NzpU5k0V7qn6m66s3/aWvuD/qSQuuF
 zAJWvQjTJVUVy8uh/m8dYdxk6tZ/X6pOvJG3K63Ngci9vOfoda
 8gmLRt1mG36LVuBmYWtsuu6GkrZDqPEvLCrEMHPeuM+kc3HPU6
 iIFeGrj4H9Vg/EJEVF9SE5ZzaIMBpvotqlltLJT2NmHrax6JbF
 i2OPMsL/CrDSkUO/sqqHYaHYFRWgrb7Ujf4z5lFysX8XkWZ7Wt
 WRKI/hYz2BKRk4XZ6eNE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2012, Kees Cook wrote:
> Add finit_module syscall to the ARM syscall list.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---

My Ack was on the asm-generic patch, not the ARM architecture
one. This patch looks ok as well, but Russell is the one
maintaining the file, so you should get him to Ack this patch
instead.

	Arnd
