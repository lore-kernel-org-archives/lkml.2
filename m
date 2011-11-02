Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1KBVQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:16:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1KBVQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:16:43 -0400
Message-ID: <4EB1B337.1090501@redhat.com>
Date: Wed, 02 Nov 2011 17:16:39 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most
 places
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop> <4EB17A50.6050804@redhat.com> <yun8vnywhvh.fsf@aiko.keithp.com> <4EB19BB4.6030505@redhat.com> <yunipn2uw70.fsf@aiko.keithp.com> <4EB1A9A7.8070900@redhat.com> <yun7h3iut1z.fsf@aiko.keithp.com>
In-Reply-To: <yun7h3iut1z.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 5:13 PM, Keith Packard wrote:
> On Wed, 02 Nov 2011 16:35:51 -0400, Adam Jackson<ajax@redhat.com>  wrote:
>
>> It is?  The DP 1.1a text for lane count is "For Rev.1.1, only the
>> following three values are supported. All other values are reserved."
>
> Yeah, if you look at the MAX_LINK_RATE field, we assume that it has a
> useful value. I'll bet they were thinking of letting the spec support
> things like alternate clock rates or 3 lanes or something, and the 1.1
> version just tied things down to allow only sensible values there.
>
> How about we just always use the DPCD value?

Looks good.

Reviewed-by: Adam Jackson <ajax@redhat.com>

- ajax

