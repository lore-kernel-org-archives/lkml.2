Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0DXE7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 00:59:00 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:61656 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0DXE66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 00:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <20100423135625.1e12d005.randy.dunlap@oracle.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-2-git-send-email-arve@android.com>
	 <1271984938-13920-3-git-send-email-arve@android.com>
	 <1271984938-13920-4-git-send-email-arve@android.com>
	 <1271984938-13920-5-git-send-email-arve@android.com>
	 <1271984938-13920-6-git-send-email-arve@android.com>
	 <1271984938-13920-7-git-send-email-arve@android.com>
	 <1271984938-13920-8-git-send-email-arve@android.com>
	 <1271984938-13920-9-git-send-email-arve@android.com>
	 <20100423135625.1e12d005.randy.dunlap@oracle.com>
Date: Fri, 23 Apr 2010 21:58:56 -0700
Message-ID: <v2sd6200be21004232158m3a3eaebai1ca0e49ae79e97f@mail.gmail.com>
Subject: Re: [PATCH 8/9] Input: Block suspend while event queue is not empty.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Sven Neumann <s.neumann@raumfeld.com>,
       Tero Saarni <tero.saarni@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>, Matthew Garrett <mjg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/23 Randy Dunlap <randy.dunlap@oracle.com>:
> On Thu, 22 Apr 2010 18:08:57 -0700 Arve Hjønnevåg wrote:
>
>> Add an ioctl, EVIOCSSUSPENDBLOCK, to enable a suspend_blocker that will block
>> suspend while the event queue is not empty. This allows userspace code to
>> process input events while the device appears to be asleep.
>
>
> All new ioctls need to be added to Documentation/ioctl/ioctl-number.txt, please.
>

These two appear to already be covered by "'E'     all
linux/input.h           conflict!", but I will add a line the user
space suspend blocker ioctls added earlier in this patch set.

-- 
Arve Hjønnevåg
