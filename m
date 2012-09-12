Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2ILIS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2ILIS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:18:56 -0400
Message-ID: <5050454E.5020301@redhat.com>
Date: Wed, 12 Sep 2012 10:18:22 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>  <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <1347437141.2793.2.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1347437141.2793.2.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/09/2012 10:05, James Bottomley ha scritto:
> This is why the whole filter thing was mutable via sysfs.  That way the
> admin could set this up per device.  It sounds like this is what you
> want to fix, rather than opening up more holes in an already leaky
> security apparatus.

It is, thanks for the useful history lesson!

Paolo
