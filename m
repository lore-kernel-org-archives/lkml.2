Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1HXLbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:31:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1HXLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:31:06 -0400
Date: Wed, 24 Aug 2011 15:31:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, containers@lists.osdl.org
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110824113100.GR29452@sun>
References: <20110824085329.GL29452@sun>
 <20110824111806.GA7191@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824111806.GA7191@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 03:18:06PM +0400, Vasiliy Kulikov wrote:
...
> 
> You have no ptrace_may_access() check in ->lookup(), only in ->readdir().
> 

Thanks Vasiliy! I'm reworking it anyway ;)

	Cyrill
