Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1IHFud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 01:50:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab1IHFub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 01:50:31 -0400
Date: Thu, 8 Sep 2011 09:50:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, kernel-hardening@lists.openwall.com,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110908055025.GG28162@sun>
References: <20110906101518.GA4799@albatros>
 <20110906165144.GJ18425@mtj.dyndns.org>
 <20110906172952.GA28055@albatros>
 <20110906173341.GM18425@mtj.dyndns.org>
 <20110907112301.GA12157@albatros>
 <20110907215329.GB28162@sun>
 <20110907151323.613e62e7.akpm@linux-foundation.org>
 <20110907224234.GD28162@sun>
 <20110907155332.beda7d3d.akpm@linux-foundation.org>
 <20110908054826.GF28162@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908054826.GF28162@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 09:48:26AM +0400, Cyrill Gorcunov wrote:
...
> 
> Here an update is coming, please take a look. Note I simply added BUG() in case
> if preallocated array failed since found that it's what other kernel code
> does as well (ie grep for flex_array_put_ptr). Other notes are at v11: mark
> below. Thanks.
> 
> 	Cyrill
> ---
> fs, proc: Introduce the /proc/<pid>/map_files/ directory v11
> 

Crap. Andrew drop this one please.

	Cyrill
