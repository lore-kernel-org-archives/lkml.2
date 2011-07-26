Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1GZQhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:37:51 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54578 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753889Ab1GZQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:37:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=K2L9GeCrwOFYDuFT9wKwKy6GG/YDit4LxgndfSo4E2j4eWjkKfQdvrDwynJc1pRojh/6qkHJ8c3kF5yuFyN5IoTpEVEyldmYYvJPexygTfDPJDcoDIa5TDc+0GLVBa0c;
Date: Tue, 26 Jul 2011 09:37:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/5] drm/i915: Rename i915_dp_detect_common
 to intel_dp_get_dpcd
Message-ID: <20110726093736.0d052dc7@jbarnes-desktop>
In-Reply-To: <1311662194-4050-3-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
	<1311662194-4050-3-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 23:36:31 -0700
Keith Packard <keithp@keithp.com> wrote:

> This describes the function better, allowing it to be used where the
> DPCD value is relevant.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---

Ah I see you've addressed my previous comment already. :)

You can add my
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org> to 1/5 and 2/5.

-- 
Jesse Barnes, Intel Open Source Technology Center
