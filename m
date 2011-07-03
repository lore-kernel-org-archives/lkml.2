Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1GCHD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 03:03:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1GCHD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 03:03:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: deepak.sikri79@gmail.com
Subject: Re: [linux-pm] Suspend to RAm query
Date: Sun, 3 Jul 2011 09:04:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, deepaksi <deepak.sikri@st.com>,
        linux-kernel@vger.kernel.org
References: <4E09DE03.3090100@st.com>
In-Reply-To: <4E09DE03.3090100@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107030904.08190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, June 28, 2011, deepaksi wrote:
> Hi All,
> 
> I have a very basic query w.r.t the place to handle the standby/suspend
> process for the devices in the system.
> 
> Should it be done at the driver level or in the machine/platform
> specific code ?
> 
> There are instances where I need some specific functionality in the
> standby mode, or some extra functionality
> in the suspend mode at the device level. Is that the reason for
> differentiating between the suspend and standby at
> the platform code level, because in platform code we get different
> states signifying a suspend or a standby ?

Yes, it is.

The platform suspend callbacks in strcut platform_suspend_ops (as defined
in include/linux/suspend.h) take a suspend_state_t argument indicating
what state is being requested.  You can get the information from there,
if I understood your problem description correctly.

Thanks,
Rafael
