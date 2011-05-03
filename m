Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1ECRak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:30:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53103 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1ECRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:30:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: Allow setting of number of raw devices as a module parameter
Date: Tue, 3 May 2011 19:30:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1304029469-19672-1-git-send-email-jack@suse.cz> <201105031255.06410.arnd@arndb.de> <20110503162620.GD6009@quack.suse.cz>
In-Reply-To: <20110503162620.GD6009@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031930.30457.arnd@arndb.de>
X-Provags-ID: V02:K0:EZS//8ZT7nWWnCuLE++f4eVNOYb+f4q8/Ec9PJOIGMa
 /zTMuX4oCQ1ib1N77/QbS0CxDZq3MgkM2KL95MulvVU+Xab93p
 vNbhkOanLi1aGmTkPZUbRqsrvVIJJTiyfEUpPHfDfyvzVXr6ur
 3Ph5hKi3nfNVK+j1skRHRWKnU06HfZtmhCq+1OuV5wmhXjFJnA
 Si1c6jmHVIhbHWZfTiE7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 May 2011, Jan Kara wrote:
>   Yes, but in that case, I find vmalloc() the smaller pain given how obscure
> the driver is. Alan seems to have agreed as well so if you don't object
> Greg can merge the patch as is (modulo the changelog improvement from Greg)...

Yes, that's probably the best then.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
