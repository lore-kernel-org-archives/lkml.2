Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1DYVLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:11:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47877 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1DYVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=phq5/pocPJOcQTJJTzjL2LwsQDq5LvnhzQX8dSnqufdpdtXvhcFC4FJASNRzPKZUwJ
         mT3hxFP+nevshMb3wd2ekCqvxZ9Q9rwS2hA2RLL/Y+MLhfXF4zFTeaoP0Cr8Z+6DsC8/
         sOsSs5K7Dw8oZmQ8iLmehg57U8KEBHaeNaxJg=
Date: Tue, 26 Apr 2011 01:11:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Akihiro MAEDA <sola.1980.a@gmail.com>,
        Masashi YOKOTA <yokota@pylone.jp>
Subject: Re: [PATCH 0/3][RFC] Virtual Battery Driver
Message-ID: <20110425211112.GA8996@oksana.dev.rtsoft.ru>
References: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 01:20:26PM -0700, John Stultz wrote:
> So while I'm not proposing to merge this patch set as 
> is, I wanted to send it out for comment to see if there
> would be some interest or objections for merging some of
> the functionality from the virtual battery driver into
> the test_power driver?

I have no problem with test_power being more 'dynamic', so
feel free to extend it as needed.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
