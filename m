Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1JaTzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:55:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62017 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1JaTzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:55:52 -0400
MIME-Version: 1.0
In-Reply-To: <201110132145.42270.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
Date: Tue, 1 Nov 2011 03:55:50 +0800
Message-ID: <CACVXFVO_qNoy=AMs4RQOPsNq5dnTsc-=-f70Njf9Hv8eRkx=+Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 14, 2011 at 3:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Second, to address the backup problem, we need to allow user space
> processes other than the suspend/hibernate process itself to prevent the
> system from being put into sleep states.  A mechanism for that is introduced
> by the second patch in the form of the /dev/sleepctl special device working
> kind of like user space wakelocks on Android (although in a simplified
> fashion).

I also have another similar example: write(fd, buffer, 100*4096).

Suppose only 80*4096 are copied into pages of the file, then someone
run ' echo mem > /sys/power/state ' to trigger system sleep, so only
partial writing is completed before system sleep and data inconsistence
may be caused for the file on filesystem.

But I am not sure if it is possible to happen in reality.

thank,
-- 
Ming Lei
