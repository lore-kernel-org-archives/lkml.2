Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab1FAPIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:08:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45568 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1FAPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RFp9bpzzAKjTMMlIwG8FjEciRhhsKkD2EeAOtoyiv+6VZROXxwtvFRK/32xzgMSZgE
         2yVJ6dCDmX3KIy0dPGVhTd9WiaJP1gxuBdXJXzGJzrs7i9sDh5PTTpIroyB1UZOIuTLB
         EEMREDdVH9gM4dYLdxdpkV3hCDVuaD0Dc6mTc=
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
Date: Wed, 01 Jun 2011 18:03:51 +0300
Message-ID: <1306940631.4405.122.camel@localhost>
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

I'll take a look at this and fold this change in a bit later, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

