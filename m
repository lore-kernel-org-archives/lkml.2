Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1INFyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 01:54:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52883 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1INFyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 01:54:52 -0400
Date: Wed, 14 Sep 2011 09:54:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v12
Message-ID: <20110914055446.GK25367@sun>
References: <20110913211359.674453213@openvz.org>
 <20110913212447.918816776@openvz.org>
 <20110914023428.GA4034@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914023428.GA4034@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 05:34:28AM +0300, Kirill A. Shutemov wrote:
...
> > 
> > Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Tejun Heo <tj@kernel.org>
> > CC: Vasiliy Kulikov <segoon@openwall.com>
> > CC: "Kirill A. Shutemov" <kirill@shutemov.name>
> > CC: Alexey Dobriyan <adobriyan@gmail.com>
> > CC: Al Viro <viro@ZenIV.linux.org.uk>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> 
> Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
>

Thanks for review, Kirill!
