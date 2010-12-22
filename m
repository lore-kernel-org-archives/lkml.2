Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0LVRSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:18:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18307 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab0LVRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:18:13 -0500
Date: Wed, 22 Dec 2010 09:17:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: tapio.vihuri@nokia.com
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        samu.p.onkalo@nokia.com
Subject: Re: [PATCH 2/3] ECI: introducing ECI bus driver
Message-Id: <20101222091751.10009e90.randy.dunlap@oracle.com>
In-Reply-To: <1293020435-5680-3-git-send-email-tapio.vihuri@nokia.com>
References: <1293020435-5680-1-git-send-email-tapio.vihuri@nokia.com>
	<1293020435-5680-2-git-send-email-tapio.vihuri@nokia.com>
	<1293020435-5680-3-git-send-email-tapio.vihuri@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 14:20:34 +0200 tapio.vihuri@nokia.com wrote:

> From: Tapio Vihuri <tapio.vihuri@nokia.com>
> 
> ECI bus controller is kind of bridge between host CPU I2C and ECI accessory
> ECI communication.
> 
> Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
> ---
>  drivers/Kconfig           |    2 +
>  drivers/Makefile          |    1 +
>  drivers/ecibus/Kconfig    |   46 ++++
>  drivers/ecibus/Makefile   |   10 +
>  drivers/ecibus/ecibus.c   |  583 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/input/eci.h |    8 +
>  6 files changed, 650 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ecibus/Kconfig
>  create mode 100644 drivers/ecibus/Makefile
>  create mode 100644 drivers/ecibus/ecibus.c


ERROR: "intel_scu_ipc_iowrite8" [drivers/ecibus/ecibus.ko] undefined!

You must have had some kernel config enabled that I don't have enabled
when you built this.  Please fix Kconfig files so that this won't happen.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
