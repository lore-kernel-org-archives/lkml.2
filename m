Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591Ab2EQWrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:47:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030492Ab2EQWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:47:09 -0400
Date: Thu, 17 May 2012 15:47:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vladimir =?UTF-8?Q?'=CF=86-coder/phcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add Apple NLS
Message-Id: <20120517154707.c3dc2795.akpm@linux-foundation.org>
In-Reply-To: <4FAFBE24.7000307@gmail.com>
References: <4FAFBE24.7000307@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2012 15:59:00 +0200
Vladimir '__-coder/phcoder' Serbinenko  <phcoder@gmail.com> wrote:

> HFS has support for NLS. However the relevant NLS tables are missing.
> Here are they automatically transformed from the tables at unicode.org.
> Codepages requiring special handling like CJK, RTL or Brahmic ones aren't
> included in this patch.
> 
> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
> 
> Patch itself is at http://download-mirror.savannah.gnu.org/releases/grub/phcoder/nls.diff due to its size (309K)
> 

Thanks, this looks useful.

 fs/nls/Kconfig           |  157 +++++++++
 fs/nls/Makefile          |   23 +
 fs/nls/nls_macceltic.c   |  566 ++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccenteuro.c |  496 ++++++++++++++++++++++++++++++
 fs/nls/nls_maccroatian.c |  566 ++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccyrillic.c |  461 ++++++++++++++++++++++++++++
 fs/nls/nls_macgaelic.c   |  531 ++++++++++++++++++++++++++++++++
 fs/nls/nls_macgreek.c    |  461 ++++++++++++++++++++++++++++
 fs/nls/nls_maciceland.c  |  566 ++++++++++++++++++++++++++++++++++
 fs/nls/nls_macinuit.c    |  496 ++++++++++++++++++++++++++++++
 fs/nls/nls_macroman.c    |  601 +++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macromanian.c |  566 ++++++++++++++++++++++++++++++++++
 fs/nls/nls_macturkish.c  |  566 ++++++++++++++++++++++++++++++++++
 13 files changed, 6055 insertions(+), 1 deletion(-)

http://unicode.org/copyright.html#Exhibit1 discusses our ability to use
unicode.org data:

(a) the above copyright notice(s) and this permission notice appear
    with all copies of the Data Files or Software,

(b) both the above copyright notice(s) and this permission notice
    appear in associated documentation, and

(c) there is clear notice in each modified Data File or in the
    Software as well as in the documentation associated with the Data
    File(s) or Software that the data or software has been modified.

>From my reading, your patch does not comply with provision (a), so I
modified it as below.


Also, I note that the unicode files have

	MODULE_LICENSE("Dual BSD/GPL");

Where did this come from?  Is this a thing you decided upon or is it
unicode.org's license requirement?




From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-nls-add-apple-nls-fix

add unicode.org copyright and permission notices

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Vladimir Serbinenko <phcoder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nls/nls_macceltic.c   |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccenteuro.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccroatian.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccyrillic.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macgaelic.c   |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macgreek.c    |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maciceland.c  |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macinuit.c    |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macroman.c    |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macromanian.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macturkish.c  |   36 ++++++++++++++++++++++++++++++++++++
 11 files changed, 396 insertions(+)

diff -puN fs/nls/Kconfig~fs-nls-add-apple-nls-fix fs/nls/Kconfig
diff -puN fs/nls/Makefile~fs-nls-add-apple-nls-fix fs/nls/Makefile
diff -puN fs/nls/nls_macceltic.c~fs-nls-add-apple-nls-fix fs/nls/nls_macceltic.c
--- a/fs/nls/nls_macceltic.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macceltic.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maccenteuro.c~fs-nls-add-apple-nls-fix fs/nls/nls_maccenteuro.c
--- a/fs/nls/nls_maccenteuro.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maccenteuro.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maccroatian.c~fs-nls-add-apple-nls-fix fs/nls/nls_maccroatian.c
--- a/fs/nls/nls_maccroatian.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maccroatian.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maccyrillic.c~fs-nls-add-apple-nls-fix fs/nls/nls_maccyrillic.c
--- a/fs/nls/nls_maccyrillic.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maccyrillic.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macgaelic.c~fs-nls-add-apple-nls-fix fs/nls/nls_macgaelic.c
--- a/fs/nls/nls_macgaelic.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macgaelic.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macgreek.c~fs-nls-add-apple-nls-fix fs/nls/nls_macgreek.c
--- a/fs/nls/nls_macgreek.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macgreek.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maciceland.c~fs-nls-add-apple-nls-fix fs/nls/nls_maciceland.c
--- a/fs/nls/nls_maciceland.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maciceland.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macinuit.c~fs-nls-add-apple-nls-fix fs/nls/nls_macinuit.c
--- a/fs/nls/nls_macinuit.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macinuit.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macroman.c~fs-nls-add-apple-nls-fix fs/nls/nls_macroman.c
--- a/fs/nls/nls_macroman.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macroman.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macromanian.c~fs-nls-add-apple-nls-fix fs/nls/nls_macromanian.c
--- a/fs/nls/nls_macromanian.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macromanian.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macturkish.c~fs-nls-add-apple-nls-fix fs/nls/nls_macturkish.c
--- a/fs/nls/nls_macturkish.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macturkish.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
_

