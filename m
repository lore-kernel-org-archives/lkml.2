Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1BXWVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:21:55 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57174 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab1BXWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c8nsJjyR7SWAkOlzLrcqPmRVAxhjt7CUrKhPKfMbTTh4YhXuJrpi28bi7y56a4Fs1u
         V8H4YWxi4BDM6siqi/oAmD8ZzpDKKnFPNRjSBCbSFJy114B6DstT+lXzbWw4s9iTA9HS
         DQjlQL3A/+fGDaSc/ZGRvrxrQI3CuVtJPwUq8=
Date: Thu, 24 Feb 2011 14:20:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: bcm5974 - Report button also for zero fingers
Message-ID: <20110224222058.GA2448@core.coreip.homeip.net>
References: <1298576264-1563-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298576264-1563-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 08:37:44PM +0100, Henrik Rydberg wrote:
> With the current code, pressing the integrated button with an
> isolating tool does not result in any button report. Fixed
> with this this patch.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Dmitry,
> 
> that nobody every complained about this bug is beyond me...

I guess nobody uses styluses to work with the touchpad... I'll apply it
of course, but since I do not recall bug reports I'll hold it till .39 I
think.

Thanks. 

-- 
Dmitry
