Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0FRHtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:49:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab0FRHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:49:42 -0400
Date: Fri, 18 Jun 2010 09:49:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, avi@redhat.com, mtosatti@redhat.com,
       glommer@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] Add timekeeping documentation
Message-ID: <20100618074937.GA9045@basil.fritz.box>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-18-git-send-email-zamsden@redhat.com> <87mxuuujgm.fsf@basil.nowhere.org> <4C1A901F.2010802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1A901F.2010802@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The point is about hotplug CPUs.  Any hotplugged CPU will not have a 
> perfectly synchronized TSC, ever, even on a single socket, single crystal 
> board.

hotplug was in the next section, not in this.

Besides most systems do not support hotplug CPUs.

-Andi
