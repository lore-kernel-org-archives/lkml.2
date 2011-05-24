Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab1EXS6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:58:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57636 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab1EXS6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fTCgorsN9CgBZzZ/9m643cY5G2j0Iy67Lh21Uoi8GKoAaPfDxi3UiaX++/V3qB7g8f
         OhnO688qOXgryEJLlWTqGLNwhuUnY/U69Vfx0VpiViqacEq46eLaqyVSIob6Q7mZiWiz
         8J96KQSe/8HlLzVE41jI6jSpVfgYWx1hUWDeE=
Date: Tue, 24 May 2011 22:58:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: bleung@google.com, olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] power: bq20z75: support external notification
Message-ID: <20110524185802.GA10075@oksana.dev.rtsoft.ru>
References: <1305846004-11895-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1305846004-11895-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:00:03PM -0700, Rhyland Klein wrote:
[...]
> +	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
> +
> +	bq20z75_device->enable_detection = true;

Um... I don't follow this part.

Especially considerting that the next patch just removes this line,
but says that it "enables detection after registering". Hm.

It says "need to enable detection" and removes "enable_detection = true".

Could you explain what's going on here? :-)

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
