Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1FYNto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 09:49:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39647 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1FYNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 09:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RN0ak07PLByRSggSK2WW3e3HhVh3toloi0lemDUVnSwwyDJDd+eXUxAI4/3DKAlAV+
         ENnj+o2McleNU/r97QAPK/VIRB8n6fQCBGfkt5BtdQIEJHWl1K7hRKC4l8EoCHDsgTlw
         5ihh5MKDErqvgQ3MR/gdZ/Q1PwtmoIA8OI7lQ=
Date: Sat, 25 Jun 2011 15:49:38 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace: kill real_parent_is_ptracer() in in favor of
 ptrace_reparented()
Message-ID: <20110625134938.GV30101@htj.dyndns.org>
References: <20110624153330.GA9346@redhat.com>
 <20110624153423.GC9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624153423.GC9346@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 05:34:23PM +0200, Oleg Nesterov wrote:
> Kill real_parent_is_ptracer() and update the callers to use
> ptrace_reparented(), after the previous patch they do the same.
> 
> Remove the unnecessary ->ptrace != 0 check in get_signal_to_deliver(),
> if ptrace_reparented() == T then the task must be ptraced.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
