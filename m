Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1DJLBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 07:01:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35327 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1DJLBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 07:01:37 -0400
MIME-Version: 1.0
X-Originating-IP: [14.99.18.150]
In-Reply-To: <105494.1302377420@localhost>
References: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
	<1302256664-23688-2-git-send-email-pavan_savoy@ti.com>
	<1302256664-23688-3-git-send-email-pavan_savoy@ti.com>
	<105494.1302377420@localhost>
Date: Sun, 10 Apr 2011 16:31:35 +0530
Message-ID: <BANLkTik0=sqE0-R7BkuJG3Qmr4W3hAXDnA@mail.gmail.com>
Subject: Re: [PATCH 2/3] drivers:misc:ti-st: remove rfkill dependency
From: Pavan Savoy <pavan_savoy@sify.com>
To: Valdis.Kletnieks@vt.edu
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 1:00 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 08 Apr 2011 04:57:43 CDT, pavan_savoy@ti.com said:
>> From: Pavan Savoy <pavan_savoy@ti.com>
>>
>> rfkill is no longer used by Texas Instruments shared transport driver to
>> communicate with user-space.
>
> Color me confoozled.  What's it using instead to provide the rfkill functionality?
>
> (I'm OK on the actual patch, just the changelog is a tad ambiguous for those
> of us tuning in late...)
>

You can have a look at, Documentation/ABI/testing/sysfs-platform-kim
