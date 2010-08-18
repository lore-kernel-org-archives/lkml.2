Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0HRIms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:42:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:44929 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab0HRImp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:42:45 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Ike Panhc <ike.pan@canonical.com>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@novell.com>
Subject: Re: [PATCH 5/8] ideapad: use EC command to control camera
Date: Wed, 18 Aug 2010 10:42:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282120695-11503-1-git-send-email-ike.pan@canonical.com>
In-Reply-To: <1282120695-11503-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181042.39943.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. August 2010, 10:38:15 schrieb Ike Panhc:
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  drivers/platform/x86/ideapad_acpi.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)

Hi,

wouldn't it be appropriate to integrate such switches into the generic
power framework?

	Regards
		Oliver
