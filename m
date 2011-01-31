Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1AaNT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:19:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48814 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1AaNT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:19:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k84cL0EZeeb17n25x7KvUzH0Ivb4dLkGTlfjUV9n/90WHAF2H8z23x5oHlHOiyn8Sj
         t8verDHV5o70TXgQe847wqgyjLLzTUZ9oE8NCEhdFk1ImGcJQFPXTYw2eoyp1KwXDvfn
         9jBoTeUY6sWmZjQO3CgnCdDIa+8WoQLKncPds=
Date: Mon, 31 Jan 2011 16:19:52 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: olofj@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] power: bq20z75: add support for charge properties
Message-ID: <20110131131952.GA22005@oksana.dev.rtsoft.ru>
References: <1295982606-4604-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1295982606-4604-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:10:06AM -0800, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> Adding support for charge properties for gas gauge.
> Also ensuring that battery mode is correct now for energy as well as
> charge properties by setting it on the fly.
> 
> I also added 2 functions to power_supply.h to help identify the units for
> specific properties more easily by power supplies.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---

Applied with some cosmetic changes.

[...]
> +static inline bool power_supply_is_amp_property(
> +	enum power_supply_property psp){

Fixed style issues here.

[...]
> +static inline bool power_supply_is_watt_property(
> +	enum power_supply_property psp){

And here.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
