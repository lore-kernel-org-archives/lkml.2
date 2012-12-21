Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab2LUIqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:46:55 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:58452 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LUIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:46:50 -0500
MIME-Version: 1.0
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5924D729@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
	<50D41860.7040406@nvidia.com>
	<4D68720C2E767A4AA6A8796D42C8EB5924D729@BGSMSX101.gar.corp.intel.com>
Date: Fri, 21 Dec 2012 16:46:50 +0800
Message-ID: <CAJLyvQztwuvG0GooBUKApR+VnP9=yxKUu6sRn1AqR8Sno_MP8Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] Thermal Framework Enhancements
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Wei Ni <wni@nvidia.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 December 2012 16:30, R, Durgadoss <durgadoss.r@intel.com> wrote:
> Hi Ni,
>
>> -----Original Message-----
>> From: Wei Ni [mailto:wni@nvidia.com]
>> Sent: Friday, December 21, 2012 1:36 PM
>> To: R, Durgadoss
>> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> hongbo.zhang@linaro.org
>> Subject: Re: [PATCH 0/8] Thermal Framework Enhancements
>>
>> On 12/18/2012 05:29 PM, Durgadoss R wrote:
>> > This patch is a v1 based on the RFC submitted here:
>> > https://patchwork.kernel.org/patch/1758921/
>> >
>> > This patch set is based on Rui's -thermal tree, and is
>> > tested on a Core-i5 and an Atom netbook.
>> >
>> > This series contains 8 patches:
>> > Patch 1/8: Creates new sensor level APIs
>> > Patch 2/8: Creates new zone level APIs. The existing tzd structure is
>> >            kept as such for clarity and compatibility purposes.
>> > Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
>> >            existing tcd structure need not be modified.
>> > Patch 4/8: Adds a thermal_trip sysfs node, which exposes various trip
>> >            points for all sensors present in a zone.
>> > Patch 5/8: Adds a thermal_map sysfs node. It is a compact representation
>> >            of the binding relationship between a sensor and a cdev,
>> >            within a zone.
>> > Patch 6/8: Creates Documentation for the new APIs. A new file is
>> >            created for clarity. Final goal is to merge with the existing
>> >            file or refactor the files, as whatever seems appropriate.
>> > Patch 7/8: Make PER ZONE values configurable through Kconfig
>> > Patch 8/8: A dummy driver that can be used for testing. This is not for
>> merge.
>>
>> I read these patches, they create new APIs and sysfs, but it seems they
>> didn't use the thermal_zone to handle the thermal_throttle issue,
>> something like update thermal_zone, update temperature, handle
>> governors
>> when cross the trip temp. So will you send out next serial patches for
>> these implementation?
>
> Yes, once these get into Rui's tree, we will start migrating the existing drivers/
> and governors, to get things working.
Durgadoss,
See function psy_register_thermal() in power_supply_core.c,
thermal_zone_device_register() is used here, what will this look like
in future?
Create thermal zone here?
Or add sensor to thermal zone? if so, how do we know which zone to add
sensor to?


>
> Thanks,
> Durga
