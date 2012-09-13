Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab2IMSCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:02:50 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44916 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755186Ab2IMSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:02:47 -0400
Message-ID: <50521FA6.7040900@xenotime.net>
Date: Thu, 13 Sep 2012 11:02:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] fs: add missing documentation to simple_xattr
 functions
References: <20120911202809.988739953@napanee.usersys.redhat.com> <20120911202810.725043407@napanee.usersys.redhat.com>
In-Reply-To: <20120911202810.725043407@napanee.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 01:28 PM, Aristeu Rozanski wrote:


+/**
+ * simple_xattr_set: xattr SET operation for in-memory/pseudo filesystems

The format for the function name/description uses '-', not ':', as:

 * simple_xattr_set - xattr SET operation for in-memory/pseudo filesystems

+ * @xattrs: simple_xattr list
+ * @name: name of the new extended attribute
+ * @value: value of the new extended attribute. If NULL, will remove the
+ *	   attribute

Missing @size parameter description.

+ * @flags: if XATTR_CREATE is set, no already existing extended attribute may
+ *	   exist. If XATTR_REPLACE is set, the extended attribute should exist.
+ *
+ * returns -ENOMEM for allocation failures, -EEXIST in case XATTR_CREATE is
+ *	   set in flags and an extended attribute with the same name exists,
+ *	   -ENODATA if XATTR_REPLACE is set in flags but no entry with the
+ *	   specified name exists.
  */
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)



-- 
~Randy
