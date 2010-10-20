Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0JTXqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:46:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60173 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0JTXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lVOnP3YJNNvXIFU9xkGTKb9IlnVZMMfvvN9lkN+MfvWmFHPzpJwH9l5t4Wqah7Djl2
         QzCPPWAsZLL3bXttEk8ynVHUQiX+3ay72yfwpWMRuREXgQogBOpE2F2SE7W9vw1QMvdj
         0cjxMYemXwnZJAUggAidrrbKVjt+emJp9s76A=
Date: Wed, 20 Oct 2010 16:46:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexey Charkov <alchark@gmail.com>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v2] input: Add support for VIA VT8500 and compatibles
 in i8042
Message-ID: <20101020234639.GA11988@core.coreip.homeip.net>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
 <1287608139-21354-3-git-send-email-alchark@gmail.com>
 <201010201415.09535.dmitry.torokhov@gmail.com>
 <20101020221449.GA30322@alchark-u3s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020221449.GA30322@alchark-u3s.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 02:14:49AM +0400, Alexey Charkov wrote:
> VIA and WonderMedia Systems-on-Chip feature a standard i8042-compatible
> keyboard and mouse controller. This adds necessary glue to enable use
> of the standard driver with these systems.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
