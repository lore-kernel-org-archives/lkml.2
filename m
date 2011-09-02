Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab1IBB6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:58:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40465 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab1IBB6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:58:17 -0400
Date: Fri, 2 Sep 2011 10:58:07 +0900
From: Tejun Heo <tj@kernel.org>
To: Nicholas Miell <nmiell@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110902015807.GG2752@htj.dyndns.org>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <4E603758.6050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E603758.6050003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 06:54:32PM -0700, Nicholas Miell wrote:
> This doesn't seem to fully export all the information passed to mmap(2)
> -- it encompasses the addr, size, fd and (assuming the generated
> symlink's permissions are accurate) prot parameters, but does nothing to
> export the flags or offset parameters.

It looks like,

/proc/*/fd : fdinfo ~= map_files : maps

-- 
tejun
