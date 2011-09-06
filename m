Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1IFSPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:15:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42455 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1IFSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:15:31 -0400
Date: Tue, 6 Sep 2011 22:15:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20110906181525.GC19452@sun>
References: <20110901080508.GF30615@sun>
 <20110902163711.GA3124@albatros>
 <20110905185358.GA2103@albatros>
 <20110905192009.GJ761@sun>
 <20110905194908.GA2690@albatros>
 <20110905203627.GL761@sun>
 <20110906101518.GA4799@albatros>
 <20110906165144.GJ18425@mtj.dyndns.org>
 <20110906172952.GA28055@albatros>
 <20110906173341.GM18425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906173341.GM18425@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:33:41AM +0900, Tejun Heo wrote:
...
> 
> Yeap, I know there are two sides of the discussion but if one takes
> the position that hiding such global debug info is more harmful, it's
> only crazier to hide such information from each individual users of
> the said global facility.  So, let's just forget about information
> leak via freeing or not freeing here.  It's the wrong battle field.
>

Heh, I definitely didn't expect all this would turn out into slabinfo ;)
 
	Cyrill
