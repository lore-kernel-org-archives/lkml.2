Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1IHIvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:51:25 -0400
Received: from mail.avalus.com ([89.16.176.221]:39746 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab1IHIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:51:24 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Sep 2011 04:51:24 EDT
Date: Thu, 08 Sep 2011 09:42:12 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
cc: nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>,
        Alex Bligh <alex@alex.org.uk>
Subject: Re: [Nbd] [PATCH v2 2/2] nbd: map DISCARD requests to a new nbd
 request	type
Message-ID: <0049F93FE7CC864CB1D8147A@nimrod.local>
In-Reply-To: <1315467898-23984-3-git-send-email-pbonzini@redhat.com>
References: <1315467898-23984-1-git-send-email-pbonzini@redhat.com>
 <1315467898-23984-3-git-send-email-pbonzini@redhat.com>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

--On 8 September 2011 09:44:58 +0200 Paolo Bonzini <pbonzini@redhat.com> 
wrote:

> When the feature is enabled, set QUEUE_FLAG_DISCARD and transmit those as
> NBD_CMD_TRIM requests.
>
> I used "trim" instead of "discard" to avoid confusion with the existing
> NBD_CMD_DISC that is used for disconnect.
>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Cc: <nbd-general@lists.sf.net>
> Reviewed-by: Paul Clements <Paul.Clements@steeleye.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Do you have a patch for doc/proto.txt in the NBD protocol, or indeed
a patch for the server to implement this?

-- 
Alex Bligh
