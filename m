Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0GET1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:27:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38040 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0GET1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gtvmq0HF7hlyWhBTQA46/UK4MZQN/HXZpGeh9nVtsV6IwDtB5kXxVZpOZo8vHxUh8C
         4WpUMBvo5mO6OrpcQMA5doqqVyisDJAjYNgFRBffnedPRg61SuKNg723prDay4B7wUXb
         PhrhZT027gWhWuvI/gBZSR1i4z9H9cdW+bXo0=
Date: Mon, 5 Jul 2010 21:27:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 5/6] v4l: convert v4l2-dev to unlocked_ioctl
Message-ID: <20100705192731.GD5240@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278195310-25590-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 12:15:09AM +0200, Arnd Bergmann wrote:
> v4l2 implements two separate file operations for drivers that use locked
> and unlocked ioctl callbacks. Since we want to remove the ioctl file operation
> in favor of the unlocked variant, this separation no longer seems helpful.
> 
> There is another series from Frederic Weisbecker that takes care
> of converting all v4l drivers to use the unlocked_ioctl variant, which
> brings the BKL pushdown one level further.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>



Mauro, would you prefer to take this version or the other that does the complete
v4l pushdown?

I can rebase the other series to the latest v4l branch if needed.


Thanks.


> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

