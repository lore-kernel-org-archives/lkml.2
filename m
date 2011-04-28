Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1D1GY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:24:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1D1GYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I5hGyKa28Co0hUYJW+APLcNmH/bCcT1E46yQ5GG4qzqAlzuUqWThNvDv7ddIL8475a
         gE2DVxSRrhgH/KBrIg31x9O6niUFUffSLJVQVftk2qCm7YQMXLuJ91Lq4HU3FDS5Hvb/
         14fYqJUd7AWs3hITQOFZlc0FIRFrSduYXBLHo=
Date: Wed, 27 Apr 2011 23:24:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: rydberg@euromail.se, olof@lixom.net, amartin@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2] Input: tegra-kbc - add ghost key filter.
Message-ID: <20110428062418.GB31734@core.coreip.homeip.net>
References: <1303423815-22786-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303423815-22786-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 03:10:15PM -0700, riyer@nvidia.com wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
> 
> Add ghost key filtering support for the Nvidia Tegra matrix keyboard.
> 

Queued for 2.6.40, thanks Rakesh.

-- 
Dmitry
