Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0DACmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab0DACmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:42:04 -0400
Subject: Re: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <20100331163234.8e875ae8.akpm@linux-foundation.org>
References: <1269775909.5301.4.camel@localhost.localdomain>
	 <20100331163234.8e875ae8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 22:41:36 -0400
Message-ID: <1270089696.2941.217.camel@dhcp235-240.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 16:32 -0700, Andrew Morton wrote:
> On Sun, 28 Mar 2010 13:31:49 +0200
> Thomas Meyer <thomas@m3y3r.de> wrote:
> 
> > This warning/error/notice is new in 2.6.34-rc2+:
> 
> Let's add some cc's.  It might be a DRM bug.
> 
> I'll ask Rafael and Maciej to track this as a post-2.6.33 regression,
> thanks.

The IMA code hasn't changed since .33 so my guess is something new the
drm code is doing with obj->filp.

Thomas, any idea what the newest kernel was that didn't show you this
problem?  It might help cut down my search in the morning....

-Eric

