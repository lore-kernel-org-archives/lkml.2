Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1AYOTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:19:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63522 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1AYOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ok5E4d2FIgsjQPAwEhWleudNWr39gYEukuBF9Ej2Z0/Gq3vWurtmzqJCwov6WpSt8B
         PxwwCPWB8hla0DJEUHdRjKE9cBv+RHz5kIuXA1PEralRH+7wjQcBFPxIuNJZLM8S2Ejs
         IwVo3LHwHpsv6+32uecXSSSDVEyGbZUkPswKc=
Date: Tue, 25 Jan 2011 15:19:42 +0100
From: Tejun Heo <tj@kernel.org>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 10/32] input/tps6507x-ts: use system_wq instead of
 dedicated workqueue
Message-ID: <20110125141942.GA27510@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-11-git-send-email-tj@kernel.org>
 <20110103143926.GX1886@bicker>
 <4D21FAA3.8030505@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D21FAA3.8030505@ridgerun.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 09:34:43AM -0700, Todd Fischer wrote:
> Hi Dan,
> 
> Polling is only necessary because I was given brain dead hardware.
> I was expecting updated hardware with the interrupt signal connected
> properly, but haven't received it yet.
> 
> Any reasonable hardware will not need tps6507x-ts polling.  I was
> under the impression I could only push patches that I have tested.
> Since I haven't tested an interrupt version of the driver, I didn't
> include a patch that removes the polling and replaces it with
> interrupts.
> 
> I have another customer planning on using the TPS6507x chip for
> touch screen.  I expect their hardware in around 3 weeks.

Shall I apply the patch?

Thanks.

-- 
tejun
