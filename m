Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab1IBCaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:30:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab1IBCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:30:06 -0400
Date: Fri, 2 Sep 2011 11:29:57 +0900
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
Message-ID: <20110902022957.GH2752@htj.dyndns.org>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <4E603758.6050003@gmail.com>
 <20110902015807.GG2752@htj.dyndns.org>
 <4E6039BA.1010805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6039BA.1010805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 01, 2011 at 07:04:42PM -0700, Nicholas Miell wrote:
> So are the filenames in /proc/$PID/map_files/ guaranteed to be identical
> to the first field (first two fields? the part before the first space)
> in /proc/$PID/maps?

Yeap, naturally.

> When I open a file in /proc/$PID/map_files/, is offset 0 the start of
> the file on disk or is it the first byte of the mapping?

It shows the same backing file so of course uses the same offset as
the file on disk.

Thanks.

-- 
tejun
