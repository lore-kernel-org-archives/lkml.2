Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1BAK72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:59:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57331 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1BAK70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:59:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Va1JQplsrjOms0c9o7h4FDB8SVdfutSQ9xP5m5aBWc6Y6ZobfCT6azL8DRyzNrx62Y
         h/K5J/AL16NQmaw8Mph5YoE8Qp9acmG74wAqKCpY3moWGTsJUqZQkg166Qxlmdcdwhp3
         sx0mEFRMXZXUczAiG8GjugbCLSq4Qp36TGar4=
Date: Tue, 1 Feb 2011 11:58:56 +0100
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: remove bogus use of struct execute_work in sg
Message-ID: <20110201105856.GL14211@htj.dyndns.org>
References: <20110124133105.GC11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124133105.GC11404@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 02:31:05PM +0100, Tejun Heo wrote:
> execute_work usage in sg is bogus.  execute_in_process_context() is
> never used and ew is used purely as wrapper around work_struct which
> is superflous.  Use work_struct directly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
> This hasn't changed from the previous posting.
> 
>   http://thread.gmane.org/gmane.linux.scsi/62923

James, are you gonna take these two?

Thanks.

-- 
tejun
