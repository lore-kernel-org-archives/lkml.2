Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab1CAT3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:29:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53125 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1CAT3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:29:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AzWl0B7NDuvWdYt9g/txwkhwvtZrfm55oJN86AF1MQcktkrNXOEobHQyr7y9Ly1ZFM
         9qIcAPq6D7WKQJtwMzonE51rM1VxN/lDzn4Tc4nMMibrR8PUvMJLCYBbHuUdVOGHhWsn
         ruNQUHYscG1m6rN+u7QyEksR60jgDAGfeMMsk=
Date: Tue, 1 Mar 2011 22:28:56 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rhyland Klein <rklein@nvidia.com>
Subject: Re: [PATCH 1/3] power: bq20z75: add MODULE_DEVICE_TABLE
Message-ID: <20110301192856.GA5649@oksana.dev.rtsoft.ru>
References: <1298971353.17825.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298971353.17825.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 05:22:33PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding the MODULE_DEVICE_TABLE, below entry will be added to
> modules.alias:
> alias i2c:bq20z75 bq20z75
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied all three patches, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
