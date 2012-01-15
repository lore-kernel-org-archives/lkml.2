Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2AOS5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:57:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49203 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2AOS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:57:53 -0500
Date: Sun, 15 Jan 2012 22:57:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v5
Message-ID: <20120115185748.GO2067@moon>
References: <20111228121407.GL27266@moon>
 <20120115180721.GA23810@redhat.com>
 <20120115183145.GH3186@moon>
 <20120115184806.GA25928@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115184806.GA25928@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 07:48:06PM +0100, Oleg Nesterov wrote:
> 
> Why not? What is the problem to know the pid of this child? And once
> again, you can list all children without this patch anyway.
> 
> Perhaps I missed something, but I simply don't understand the problem.
> 

Dunno, that's why  I asked. But indeed I somehow forgot that I can
find all children anyway. I'll drop this snippets. Thanks!

	Cyrill
