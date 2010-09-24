Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0IXTTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:19:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36395 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab0IXTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:19:20 -0400
MIME-Version: 1.0
X-Originating-IP: [192.94.94.105]
In-Reply-To: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
References: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
Date: Fri, 24 Sep 2010 14:19:18 -0500
Message-ID: <AANLkTin0UA_=yNbnTSHovZxByBaJUESH0a=8-=5b5HkS@mail.gmail.com>
Subject: Re: drivers:staging:ti-st: merge issues.
From: Pavan Savoy <pavan_savoy@sify.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, anca.emanuel@gmail.com
Cc: pavan_savoy@sify.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ emanuel,

On Fri, Sep 24, 2010 at 2:11 PM, Pavan Savoy <pavan_savoy@ti.com> wrote:
> Stephen,
>
> The merges bbf96b3cb54a237f1a66883390637e30bb4407ba and the merge on
> 759b9f0fe0c5be0d9fa1b92e14e093961312f6ac has caused the
> drivers/staging/ti-st to get corrupted, I had submitted few patches
> and it was all merged.
>
> basically the merge for bbf96b3cb54a237f1a66883390637e30bb4407ba for
> drivers/staging/ti-st/ shouldn't have happened.
> The head for the drivers/staging/ti-st/ should have been @
> 83ef41f0858b48cce4f8ca23f674ec55d50bf47d

Upon emanuel's request the patch was brought in again to staging-next,
whose merge into linux-next has caused all the problems.
Now what needs to be done?

> This is causing build failure.
>
