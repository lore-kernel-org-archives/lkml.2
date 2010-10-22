Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0JVX4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:56:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756621Ab0JVX4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:56:18 -0400
Date: Fri, 22 Oct 2010 16:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dave@gnu.org
Cc: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH RESEND] drm: include missing types header to drm_mode.h
Message-Id: <20101022165517.effde8fb.akpm@linux-foundation.org>
In-Reply-To: <1287753199.2122.0.camel@cowboy>
References: <1287753199.2122.0.camel@cowboy>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 10:13:19 -0300
Davidlohr Bueso <dave@gnu.org> wrote:

> drm: include missing types header to drm_mode.h
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  include/drm/drm_mode.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> index 0fc7397..eddd7f4 100644
> --- a/include/drm/drm_mode.h
> +++ b/include/drm/drm_mode.h
> @@ -24,6 +24,8 @@
>   * IN THE SOFTWARE.
>   */
>  
> +#include <linux/types.h>
> +
>  #ifndef _DRM_MODE_H
>  #define _DRM_MODE_H
>  

Does this fix a build error?  If so, please send along the compiler
error output.

