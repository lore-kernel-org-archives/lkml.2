Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab1FAPSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:18:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab1FAPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AvSxAk2RE224o5rHxR+bdLhUi7JiskAUJ1S6UUs6jyTeBewsg4JVV4fcewguHCT3q8
         wkXE0zA1IPRMJnQ3pf4dYz8tBelrvIdibZXR4XBQ8UvW+1idAWF5Sy9U9UDEt3htX687
         tsiLhkzO+fTcgchk+0Wvzt2rbIByUnolSK0t8=
Subject: Re: [PATCH] UBIFS: fixup merged 'UBIFS: fix-up free space earlier'
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
In-Reply-To: <1306940008-28454-1-git-send-email-bengardiner@nanometrics.ca>
References: <1306923407.4405.94.camel@localhost>
	 <1306940008-28454-1-git-send-email-bengardiner@nanometrics.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 18:14:16 +0300
Message-ID: <1306941256.4405.123.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 10:53 -0400, Ben Gardiner wrote:
> When the patch 'UBIFS: intialize LPT earlier' was massaged before being applied
> the context of the next patch 'UBIFS: fix-up free space earlier' was muddled
> sufficiently for the order of allocate-lpt then free-space-fixup was reversed --
> I think.
> 
> Put the free-space-fixup after allocate-lpt.
> 
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> 
> ---
> With this fixup applied on-top-of the ubifs-2.6 master I am able to mount a
> ubinized image containing a UBIFS volume which has the free-space-fixup flag
> set. No assertions are displayed.

Thanks. Merged this patch to the 3rd one and pushed out.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

