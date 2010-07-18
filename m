Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0GRJnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:43:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43738 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0GRJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zb6PoQ6FGJPBIzhwngs648tZC4BJ3x2tbr79ualzvNdRCWVF8ZIafpb3jtP2uzDdOf
         Oi5qhsNpZPc8MRRpOEvQiZy8rtrJj+l7HK01Eu+dLMrHSxZARV2VPHaoAZR/0Mu82iP9
         jAdGIXWw0GxyJJ+iSOadU/BVR06x35XrBZlJ4=
Subject: Re: [RFC][PATCH 01/16] writeback: do not self-wakeup
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100718064435.GA23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
	 <1279284312-2411-2-git-send-email-dedekind1@gmail.com>
	 <20100718064435.GA23811@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 12:43:09 +0300
Message-Id: <1279446189.16247.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 02:44 -0400, Christoph Hellwig wrote:
> On Fri, Jul 16, 2010 at 03:44:57PM +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > The bdi forker thread wakes up itself via 'bdi_add_to_pending()'.
> > And the thread is the only user of 'bdi_add_to_pending()'. Thus,
> > we can safely zap the unneeded 'wake_up_process()' call.
> 
> At least right now it's called using call_rcu, which offloads the function
> to a RCU thread of some sorts.

Christoph, thanks for your review. I'll amend my series and re-send. And
I also have to think about some of your suggestions.

I did not CC you to spam your mailbox less, since I'm sure you would not
miss the series in the fsdevel ML. But if you prefer being CCed, let me
know.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

