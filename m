Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1DSRsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:48:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47685 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1DSRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pq+GB3OE2xP10DHdXwbemZ7cHt19vKFoCQukKJUsGNNRikUzFLtcpnyROHCtUxlYIV
         lKO/7NN/EwyVXxUOkW+0Hayr0ij8rBMcci7mGWE9lEU1MSErHmJJtNtB3lAifyWc6whb
         7YXqTTCLQSbCLhD3qlATYiKn95zmvUyEFyhCY=
Date: Tue, 19 Apr 2011 21:48:13 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <greg@kroah.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] char: agp: fix OOM and buffer overflow
Message-ID: <20110419174813.GA27544@albatros>
References: <1302800120-31560-1-git-send-email-segoon@openwall.com>
 <20110419162157.GD23196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419162157.GD23196@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 09:21 -0700, Greg KH wrote:
> David, what ever happened to this, and the other agp bugfix from
> Vasiliy?

I got emails that both fixes went into -mm.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
