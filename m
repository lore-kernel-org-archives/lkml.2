Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab0IHI6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:58:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40118 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab0IHI6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PqCeYsnM1Q7KSNxdjayOJXNkMkfYnjkPr465AFbJGnMAQR7pZRhf9E23c1mrykVUo1
         KquaohLWZzzJ52ybC+uDofWPChL6yKQgh7cJb29yFu6lGOAVCkPTQUZ6wNwhUe0n7g72
         cd6ZeTZBTZe8LQ64+QuHtpRVqRV2kdtUzSZX4=
Subject: Re: [PATCH 2/5] backing-dev: kill unused bdi_writeback->nr
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <1283777182-11426-3-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
	 <1283777182-11426-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 11:57:18 +0300
Message-ID: <1283936238.2979.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 14:46 +0200, Tejun Heo wrote:
> bdi_writeback->nr is no longer used.  Kill it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

This is obviously an independent clean-up which can be picked straight
away?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

