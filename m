Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1ELShv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:37:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab1ELShs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:37:48 -0400
Date: Thu, 12 May 2011 14:37:41 -0400
From: Dave Jones <davej@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: eranian@google.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512183741.GA22269@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Miller <davem@davemloft.net>, eranian@google.com,
	acme@redhat.com, linux-kernel@vger.kernel.org
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <20110512.140630.1779004012724490077.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512.140630.1779004012724490077.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:06:30PM -0400, David Miller wrote:
 > From: Stephane Eranian <eranian@google.com>
 > Date: Thu, 12 May 2011 16:48:46 +0200
 > 
 > > I think there is a serious problem with kernel symbol correlation
 > > with the latest perf in 2.6.39-rc7-tip.
 > 
 > The behavior seems to be intentional, so that we don't expose internal
 > kernel addresses to userspace.

Sounds like commit 9f36e2c448007b54851e7e4fa48da97d1477a175

 > I hate this too, and I think it's absolutely rediculous.
 > 
 > Also, like you, I lost an entire afternoon trying to figure out why
 > this started happening.
 > 
 > I wish we could revert this change.

At least it can be permanently disabled..

echo kernel.kptr_restrict = 0 >> /etc/sysctl.conf

	Dave

