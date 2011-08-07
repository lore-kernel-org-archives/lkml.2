Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1HGVMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:12:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab1HGVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:12:00 -0400
Date: Mon, 8 Aug 2011 01:11:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [patch 1/4] proc: Introduce the /proc/<pid>/mfd/ directory
Message-ID: <20110807211154.GF2080@sun>
References: <20110807210112.245578619@openvz.org>
 <20110807210526.741513583@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110807210526.741513583@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:01:13AM +0400, Cyrill Gorcunov wrote:
> From: Pavel Emelyanov <xemul@parallels.com>
> 
> This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
> one for each mapping with file, the name of a symlink is vma->vm_start, the
> target is the file. Opening a symlink results in a file that point exactly
> to the same inode as them vma's one.
> 
> This thing is aimed to help checkpointing processes.
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Reviewed-by: Tejun Heo <tj@kernel.org>

Ouch, Tejun, I occasionally put your Reviewed-by tag to the wrong patch :/
Sorry. 

> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
