Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0I1Mox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:44:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0I1Mow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=amw+u2j3Z1AlT+T66YeKumQEot2wv4kk4yI96rcbaTP1yakIWKUi4mttBChkOJh2ph
         0X3UwvR1kkFz4yhV/VElCbHxIZ/JE0IYjy66T0WRIaqlH9IXIZnWEam5IEP6qhsEnTSh
         DXK5gpH1DLjcw0jBk6ltELVInhWu8HgoK0Tro=
Date: Tue, 28 Sep 2010 16:44:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org, olof@lixom.net,
        achew@nvidia.com
Subject: Re: [PATCH 1/1] power: bq20z75: Adding Devicekit Power support
Message-ID: <20100928124445.GA30888@oksana.dev.rtsoft.ru>
References: <1285108435-30044-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1285108435-30044-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 03:33:55PM -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> Adding properties to support devicekit power.
> Also create io wrapper functions and fixed some issues found while
> testing, including unit conversions to match the power_supply types.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

Applied, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
