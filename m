Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1BHR6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:58:38 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64890 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1BHR6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KfMcLiiZ1Jwx/CZcr2VVLffauTUkBlR3KFiUaffNbddSuqiHHYjx0UEuHeb7Q+dY39
         H/shbyLwPpzgEyXnWtPKjXpC09qBBrjB8llQHjmBVKB/pURw0yahTU6vDtWJ1kIE5G4S
         +Weio5p/JpUtqkKNKp7XTmql3v9s2tawEmPaU=
Date: Tue, 8 Feb 2011 09:58:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH wq#for-2.6.39] workqueue: add system_freezeable_wq
Message-ID: <20110208175825.GE4476@core.coreip.homeip.net>
References: <201102080029.57195.rjw@sisk.pl>
 <20110208044712.GA906@core.coreip.homeip.net>
 <201102081020.25646.rjw@sisk.pl>
 <20110208093212.GA6558@htj.dyndns.org>
 <20110208094155.GB6558@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208094155.GB6558@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 10:41:55AM +0100, Tejun Heo wrote:
> From de62c151df9b6568c67977920267392c432f340a Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 8 Feb 2011 10:39:03 +0100
> 
> Add system wide freezeable workqueue.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

And if, as Alan said, it could be "freezable" that would be great.

-- 
Dmitry
