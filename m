Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab1ELRd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:33:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab1ELRd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H+BEkb8uaBamP5Gy5+8dvmzPrAWyN2wuP9AoJhw3knq9Ln+nkzyPB5/7OWTxe8WQ/O
         HhYneg4UY8kTFKdqnMVmtZppUq9AkTkbXAlHow4lM+aReewd9m9cVvlGuAGYGqMyKgzv
         IibSocZPx4HOCtGfjzkaRr1IftseBduthcObg=
Date: Thu, 12 May 2011 19:33:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110512173321.GP1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512173228.GO1030@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 07:32:28PM +0200, Tejun Heo wrote:
> waitid(2) should always succeed as it's never consuming wait state,
> but it does, with or without the patch.  All transitions need to be

I meant "but it does fail (0 in si.si_pid)".

> made water tight to remove the bug.

-- 
tejun
