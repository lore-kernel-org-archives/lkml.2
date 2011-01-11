Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1AKPNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:13:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63240 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1AKPNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c7jivg6l1BRaINyYgOILiU8esJpmWwDfCsaGAj3NhZ9KYIcr3T57w5m5nvqU1mn0zS
         ryMXxiCmLlPVjYmjUQmIH6S6K4oReB8U1GFH0fbLcqh/skJtPHVM9IT96Z5X2Q2wj6iV
         dV02lGIwbjGH+gFTpyBAWZ/5pWTqYIef3ue+4=
Date: Tue, 11 Jan 2011 16:13:26 +0100
From: Tejun Heo <tj@kernel.org>
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Moore, Eric" <Eric.Moore@lsi.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>
Subject: Re: [PATCH 4/6] fusion: don't use flush_scheduled_work()
Message-ID: <20110111151326.GA15933@htj.dyndns.org>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
 <1292943721-4519-5-git-send-email-tj@kernel.org>
 <B2FD678A64EAAD45B089B123FDFC3ED70916AAA0@inbmail01.lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70916AAA0@inbmail01.lsi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 01:00:58PM +0530, Desai, Kashyap wrote:
> Need to add header of function mptspi_suspend.  Logical part of the
> patch looks OK to me. Please consider this patch as an ACKed by me.

Will do so.  Thank you.

-- 
tejun
