Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1ESMI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:08:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1ESMIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SeNjE7d898lLXJIIiyYY3Sp2yPKIvoZqp3DY8GgOoZpmUQovEUK6QAewkUILXbXfL/
         dYnvUg0sTFeZqHaNfYW0YpViSpkFJVJ4zQWrd/UaQ2CeZq941g5eq6xpx5DADRyjvYxv
         ysdm/O5prIVFsuW+QvlM2MFrfLW9RxrYNlsh0=
Date: Thu, 19 May 2011 14:08:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#2
Message-ID: <20110519120821.GF627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <20110518185050.GC1064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518185050.GC1064@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:50:50PM +0200, Oleg Nesterov wrote:
> On 05/16, Tejun Heo wrote:
> >
> > This patchset is on top of Oleg's ptrace branch[3] + prep patchset[2]
> > and available in the following git branch.
> 
> IIUC 8/9 from prep patchset[2] needs the fix, do_wait()->restart_syscall()
> is not right. Do you agree or I misunderstood the result of our discussion?

Yeah, I agree.  I was just waiting for review of this series before
proceeding with the next round.

Thanks.

-- 
tejun
