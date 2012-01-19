Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2ASJRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:17:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54266 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2ASJRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:17:32 -0500
MIME-Version: 1.0
In-Reply-To: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
Date: Thu, 19 Jan 2012 14:47:31 +0530
Message-ID: <CAK44p22LmkGVo0W5eoT5Ms57pkP7PbWoxNS2c8bnx=1FhBvamA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] thermal: Add generic cpu cooling devices
 according to thermal framework
From: Amit Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, amit.kachhap@linaro.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2011 20:43, Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:
> PATCH 1)  [thermal: Add a new trip type to use cooling device instance number]
> This patch adds a new trip type THERMAL_TRIP_STATE_ACTIVE which passes
> cooling device instance number and may be helpful for cpufreq cooling devices
> to take the correct cooling action.
>
> PATCH 2)  [thermal: Add generic cpu cooling implementation]
> This patch adds generic cpu cooling low level implementation through frequency
> clipping and cpu hotplug. In future, other cpu related cooling devices may be
> added here. An ACPI version of this already exists(drivers/acpi/processor_thermal.c).
> But this will be useful for platforms like ARM using the generic thermal interface
> along with the generic cpu cooling devices. The cooling device registration API's
> return cooling device pointers which can be easily binded with the thermal zone
> trip points.
>

Any comments on these patches? I submitted them quite long back.

Regards,
Amit D

>
> Amit Daniel Kachhap (2):
>  thermal: Add a new trip type to use cooling device instance number
>  thermal: Add generic cpu cooling implementation
>
>  Documentation/thermal/cpu-cooling-api.txt |   52 +++++
>  Documentation/thermal/sysfs-api.txt       |    4 +-
>  drivers/thermal/Kconfig                   |   11 +
>  drivers/thermal/Makefile                  |    1 +
>  drivers/thermal/cpu_cooling.c             |  302 +++++++++++++++++++++++++++++
>  drivers/thermal/thermal_sys.c             |   27 +++-
>  include/linux/cpu_cooling.h               |   45 +++++
>  include/linux/thermal.h                   |    1 +
>  8 files changed, 440 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/thermal/cpu-cooling-api.txt
>  create mode 100644 drivers/thermal/cpu_cooling.c
>  create mode 100644 include/linux/cpu_cooling.h
>
