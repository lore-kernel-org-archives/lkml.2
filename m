Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1ESMLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:11:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36147 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1ESMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ah3CkgyQrtnQHJ1JOt4oS1q7SqA376CrRm2ZSz3XyhuWQVhZIvisI9q8ScAmTH8OLv
         2CvIuPMrEpx/FtkjiQbykiYRSAwQwdln36U/rzlqjl2vJP6fkBA4EdQuv3E2b4DAlyxE
         jnM/sw1lkCNO6ObYnDzXCvo9PKQ6fvp5TmLBQ=
Date: Thu, 19 May 2011 14:11:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 01/10] signal: remove three noop tracehooks
Message-ID: <20110519121104.GG627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-2-git-send-email-tj@kernel.org>
 <20110518184559.GB1064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518184559.GB1064@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 18, 2011 at 08:45:59PM +0200, Oleg Nesterov wrote:
> On 05/16, Tejun Heo wrote:
> Heh. What can I say? Yes, this is true. Of course this breaks the out-of-tree
> project, completely, and you even know its name ;) Although tracehook_get_signal()
> logic was already broken by other changes...

Yeap, but with ptrace updates, tracehook behaviors, which can't even
be fully determined without consulting out-of-tree code, are bound to
change.  Now that ptrace is receiving more capabilities, I don't see
much point in maintaining them.

Thanks.

-- 
tejun
