Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2HOMlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:41:04 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41408 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2HOMlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:41:02 -0400
Subject: Re: [PATCH] act_mirred: do not drop packets when fails to mirror it
From: Jamal Hadi Salim <jhs@mojatatu.com>
Reply-To: jhs@mojatatu.com
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <20120815093756.22238.80872.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120815093756.22238.80872.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Aug 2012 08:35:41 -0400
Message-ID: <1345034141.20443.12.camel@mojatatu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-08-15 at 17:37 +0800, Jason Wang wrote:
> We drop packet unconditionally when we fail to mirror it. This is not intended
> in some cases.

Hi Jason,
Did you actually notice the behavior you described or were you going by
the XXX comment I had in the code?

cheers,
jamal

