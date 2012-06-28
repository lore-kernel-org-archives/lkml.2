Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2F1MgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2F1MgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:36:04 -0400
Message-ID: <4FEC4FAF.8030700@redhat.com>
Date: Thu, 28 Jun 2012 15:35:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v2 3/6] kvm: Sanitize KVM_IRQFD flags
References: <20120627044758.23698.249.stgit@bling.home> <20120627050924.23698.65802.stgit@bling.home> <20120627092150.GD17507@redhat.com>
In-Reply-To: <20120627092150.GD17507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 12:21 PM, Michael S. Tsirkin wrote:
> On Tue, Jun 26, 2012 at 11:09:32PM -0600, Alex Williamson wrote:
>> We only know of one so far.
>> 
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Ugh. So we have a bug: we should have sanitized the fields.
> If there's buggy userspace that only set the low bit
> it will break with this change.
> Is it too late now? Do we need KVM_IRQFD2 which
> sanitized fields properly? Avi?

We try and see.  Commit this, if somebody complain, revert after
apologizing profusely.  If no one notices, we can claim those bits.



-- 
error compiling committee.c: too many arguments to function


