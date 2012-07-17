Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2GQOel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:34:41 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:25412 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330Ab2GQOei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:34:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYSAMx2BVBbdWOb/2dsb2JhbABFhWqrPyKGXQQDgSOBB4IgAQEEASMPAQUdIwEFCwsaAgUWCwICCQMCAQIBRQYNAQcBAYgDCqogkxiBII9VgRIDlT2QCIJh
X-IronPort-AV: E=Sophos;i="4.77,603,1336341600"; 
   d="scan'208";a="544793567"
Message-ID: <500577F9.6030104@igalia.com>
Date: Tue, 17 Jul 2012 16:34:33 +0200
From: =?UTF-8?B?TWlndWVsIEfDs21leg==?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: =?UTF-8?B?TWlndWVsIEfDs21leg==?= <magomez@igalia.com>
CC: cascardo@holoscopio.com, don@syst.com.br, mjg@redhat.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1 v2] Add support for Classmate V4 accelerometer to
 classmate-laptop
References: <cover.1340971993.git.magomez@igalia.com> <cover.1340976795.git.magomez@igalia.com>
In-Reply-To: <cover.1340976795.git.magomez@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Miguel Gómez (1):
>    classmate-laptop: Add support for Classmate V4 accelerometer.
>
>   drivers/platform/x86/classmate-laptop.c |  400 ++++++++++++++++++++++++++++++-
>   1 file changed, 398 insertions(+), 2 deletions(-)

Anyone had a moment to give a look to this code? I'm eager to get some 
feedback and fix whatever is needed to put it in shape... and start 
playing Tux Racer with the Classmate 4 accelerometer :)

Regards!!

-- 
Miguel Gómez
Igalia - http://www.igalia.com


