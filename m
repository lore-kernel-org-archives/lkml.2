Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336Ab2BOAnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 19:43:42 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:59551 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598Ab2BOAnh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 19:43:37 -0500
MIME-Version: 1.0
In-Reply-To: <4F3ABB66.1040202@linux.intel.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
	<1326414530-10789-2-git-send-email-andi@firstfloor.org>
	<CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
	<4F3ABB66.1040202@linux.intel.com>
Date: Tue, 14 Feb 2012 18:43:35 -0600
Message-ID: <CAKcLGm_YeQbaenjdCg2--Gzr61SxYXP0xRPZJEtPHADiMcn0EA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add the snappy-c compressor to lib v2
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 1:52 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
>> (BTW:  If you're ever reworking this patch set, I'd like to make an ad
>> hoc request for slightly different names for fs/btrfs/snappy.c and
>> lib/snappy.c)
>
>
> Why?
>

It's not a big deal, I just found it confusing at first to see
"snappy.c" being a different file in two places.
