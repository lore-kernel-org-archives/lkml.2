Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1JCVEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:04:02 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38206 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752190Ab1JCVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:03:56 -0400
Date: Mon, 3 Oct 2011 14:03:41 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 16/21] drm/i915: edp_panel_on does not need
 to return a bool
Message-ID: <20111003140341.052fa421@jbarnes-desktop>
In-Reply-To: <1317344993-24945-17-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-17-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 18:09:48 -0700
Keith Packard <keithp@keithp.com> wrote:

> The return value was unused, so just stop doing that.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 02b5162..56146a2 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -886,14 +886,14 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
>  }
>  
>  /* Returns true if the panel was already on when called */
> -static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
> +static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
>  {

Remove the comment too?

-- 
Jesse Barnes, Intel Open Source Technology Center
