Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1FOUHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:07:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1FOUHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WE96mZs+Y0iCOLfvL1XyM+7pYPiGVjpqkyGSCuUDACM6ItX+ydaLq564Tr1vFE56OD
         CT12DnRMCB09aH4sGBCg==
Date: Wed, 15 Jun 2011 13:07:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: cfowler@opsdc.com
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic on OOM
In-Reply-To: <1308145805.2074.367.camel@compaq-desktop>
Message-ID: <alpine.DEB.2.00.1106151307230.27546@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop> <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com> <1308103443.2074.357.camel@compaq-desktop> <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com> <1308105693.2074.361.camel@compaq-desktop>
 <alpine.DEB.2.00.1106141947570.8257@chino.kir.corp.google.com> <1308145805.2074.367.camel@compaq-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Chris Fowler wrote:

> It has been almost 12 hours and no panic yet.  Externally the box seems
> unresponsive.  No response to network activity.  No keyboard response,
> etc.  On the screen I'm still seeing printk's from the hda-intel driver
> complaining about a spurious interrupt.  I'm not to concerned about that
> but it does tell me the kernel seems to be alive.
> 

You've tried 2.6.38.8?
