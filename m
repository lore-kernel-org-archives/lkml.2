Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab1FVT6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:58:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab1FVT6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:58:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 14/19] OpenRISC: Module support
Date: Wed, 22 Jun 2011 21:58:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <201106221626.12023.arnd@arndb.de> <1308770050.20122.4951.camel@localhost>
In-Reply-To: <1308770050.20122.4951.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106222158.11381.arnd@arndb.de>
X-Provags-ID: V02:K0:FodZ+szVYC/JZUvLEQb1lKDvpmVHj8ZfLJvGMXUEP3Q
 NtlM7KGnoiDUVT5WR+czPBoQsXU3vjGzHy9UHzRbgbfFHG3S/V
 GVDswK6oovoo4DI49WUonpBhOknxyp5jbLIu7r0HqhsWfF/xxZ
 r7rYvnQBzlKrtml0G94+AdjQnWimzH0ydwQuWPHRjED3KVLmR1
 7eohmm9W0FrhHN2nStneA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 21:14:10 Jonas Bonn wrote:
> What's an acceptable "comment title"?  Most other arch's seem to put the
> filename there... I understand this is undesirable, but what can I put
> there instead?  Is "OpenRISC Linux" acceptable, or is nothing at all
> preferable?
> 
> Just want to be clear about what's allowed before I go changing all of
> these...

You don't really need anything in the comment, if you want to put something
there, I'd recommend a one-line summary of what the file is used for.

	Arnd
