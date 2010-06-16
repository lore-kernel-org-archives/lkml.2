Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0FPNYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0FPNYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:24:40 -0400
Date: Wed, 16 Jun 2010 10:24:37 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] Fix deep C-state TSC desynchronization
Message-ID: <20100616132436.GJ19104@mothafucka.localdomain>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-5-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276587259-32319-5-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:34:06PM -1000, Zachary Amsden wrote:
> When CPUs with unstable TSCs enter deep C-state, TSC may stop
> running.  This causes us to require resynchronization.  Since
> we can't tell when this may potentially happen, we assume the
> worst by forcing re-compensation for it at every point the VCPU
> task is descheduled.
can't we just compensate everytime check_tsc_unstable() is true?


