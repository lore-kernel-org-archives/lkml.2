Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0L2QCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 11:02:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51065 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0L2QCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 11:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YoGKZQvNPPDj6vAuMFZ4ZLKhg7mG6oG7djumtsBjOEb3WFVfCnGenAc78k3+7phxjz
         IrqRs0zObg3ohI1nh4+viKT5/qNQPl5PnoMZg5lNADrv/SfJ/c+V7QyFQbhM7Wm03WPH
         K8xPApMoHwZYEXTgshzkXEluUcQn8fSr3v1Yw=
Date: Wed, 29 Dec 2010 17:02:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCH 10/16] ub: convert to bdops->check_events()
Message-ID: <20101229160201.GM488@htj.dyndns.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
 <1293557352-10592-11-git-send-email-tj@kernel.org>
 <20101229085329.772e1dc0@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229085329.772e1dc0@lembas.zaitcev.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 08:53:29AM -0700, Pete Zaitcev wrote:
> On Tue, 28 Dec 2010 18:29:06 +0100
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Convert from ->media_changed() to ->check_events().
> > 
> > ub buffers media changed state and clears it on revalidation.  It will
> > behave correctly with kernel event polling.
> 
> If you say so, I don't mind. I reserve the right to come back to you
> if I find breakage in testing (I have a ZIP drive that has a real
> media change).

Sure.  :-)

-- 
tejun
