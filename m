Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2JJNk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:40:29 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55673 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab2JJNkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:40:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121010133655.GA11678@kroah.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
	<1349866585-24883-3-git-send-email-dp@opensource.wolfsonmicro.com>
	<20121010133655.GA11678@kroah.com>
Date: Wed, 10 Oct 2012 09:40:23 -0400
Message-ID: <CA+5PVA473YoaLud_rDk16mM23PosCOBi+cZWTVhnUyhh6DK4WQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] firmware: Add /proc/fw_path entry to list the
 firmware paths
From: Josh Boyer <jwboyer@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 9:36 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 10, 2012 at 11:56:25AM +0100, Dimitris Papastamos wrote:
>> This patch provides the aforementioned procfs file that lists
>> the default firmware paths that are used during firmware lookup.
>>
>> The file contains a white space separated list of paths.
>>
>> There will be another patch on top of this that adds the functionality
>> to modify the paths at runtime.
>>
>> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
>
> What about /proc/sys/kernel/firmware_path instead?  Isn't that a better
> place for this?

Without painting the bikeshed too many colors, I was wondering if /proc
was the right place for this at all.  Perhaps /sys/kernel/firmware_path
or /sys/firmware/firmware_path?

josh
