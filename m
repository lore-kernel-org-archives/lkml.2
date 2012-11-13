Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2KMRn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:43:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48193 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2KMRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:43:24 -0500
Message-ID: <50A286B9.7050709@wwwdotorg.org>
Date: Tue, 13 Nov 2012 10:43:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] NVIDIA Tegra DRM driver
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de> <50A1918E.1000809@wwwdotorg.org> <20121113064748.GB31443@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121113064748.GB31443@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 11:47 PM, Thierry Reding wrote:
> On Mon, Nov 12, 2012 at 05:17:18PM -0700, Stephen Warren wrote:
>> On 11/12/2012 02:55 PM, Thierry Reding wrote:
>>> This second version of this patch series addresses all the
>>> comments received so far. Most notably it takes advantage of
>>> the debugfs helpers provided by the DRM core. Oddly enough this
>>> actually increases the line count, but that's because the
>>> helpers don't fit with the subdevices approach as implemented
>>> by this driver. However some quick discussions with Rob Clark
>>> showed that Tegra DRM is not special in this respect but other
>>> drivers may need the same functionality. Eventually the
>>> debugfs code could be reworked on top of helpers that are
>>> better suited at the design of embedded, multi-device DRM
>>> drivers.
>>> 
>>> Other than that there is some removal of code that was actually
>>> supposed to go into a later patch because it has dependencies
>>> that haven't been merged yet and some moving around of #defines
>>> and the device tree bindings documentation. Finally the driver
>>> now uses the DRM core's drm_compat_ioctl() instead of a custom
>>> and unimplemented (!) version.
>> 
>> The series,
>> 
>> Tested-by: Stephen Warren <swarren@nvidia.com>
>> 
>> (on the Harmony board's HDMI output; I'll test other
>> boards/outputs later).
> 
> You also gave an Acked-by for the DT binding documentation in the
> first version of this patchset, does it apply to the rest of the
> patch as well? That is, can I add it to patch 1?

I didn't actually read the rest of the patch since there are many
people much more familiar with the host1x/... code that will provide
useful feedback.

However, yes, I think it's fine to include my ack in the patch - it's
common to ack only parts of patches I believe.
