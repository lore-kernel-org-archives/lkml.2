Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1IBIHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:07:18 -0400
Received: from shutemov.name ([188.40.19.243]:46682 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875Ab1IBIHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:07:12 -0400
Date: Fri, 2 Sep 2011 11:07:10 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Tejun Heo <tj@kernel.org>
Cc: Nicholas Miell <nmiell@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110902080710.GA12920@shutemov.name>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <4E603758.6050003@gmail.com>
 <20110902015807.GG2752@htj.dyndns.org>
 <4E6039BA.1010805@gmail.com>
 <20110902022957.GH2752@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902022957.GH2752@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 11:29:57AM +0900, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 01, 2011 at 07:04:42PM -0700, Nicholas Miell wrote:
> > So are the filenames in /proc/$PID/map_files/ guaranteed to be identical
> > to the first field (first two fields? the part before the first space)
> > in /proc/$PID/maps?
> 
> Yeap, naturally.

Except zero padding. %08lx in maps and %lx in map_files.

-- 
 Kirill A. Shutemov
