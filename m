Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1HQVXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:23:20 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:46406 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1HQVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110817211750.GA4044@suse.de>
References: <1313613397-18126-1-git-send-email-me@akshayjoshi.com>
	<20110817211750.GA4044@suse.de>
Date: Wed, 17 Aug 2011 17:23:16 -0400
Message-ID: <CAOJpy9uJ1mozz4FgY=Pej9TZNbbv0rSGX5dm3M3g3Lh7DONM=A@mail.gmail.com>
Subject: Re: [PATCH] Staging: nvec: Fixed various style issues.
From: Akshay Joshi <me@akshayjoshi.com>
To: Greg KH <gregkh@suse.de>
Cc: Marc Dietrich <marvin24@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
        Vitaliy Ivanov <vitalivanov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I split by file or should I redo it by splitting the changes into
different commits?

Akshay

On Wed, Aug 17, 2011 at 5:17 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Aug 17, 2011 at 04:36:32PM -0400, Akshay Joshi wrote:
>> Removed trailing spaces, brace/parenthesis issues and other coding style
>> problems, along with commented out code.
>
> Please break this into individual patches, one per logical change, so we
> can properly review it and apply it easier.
>
> thanks,
>
> greg k-h
>
