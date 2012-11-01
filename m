Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369Ab2KAMz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:55:57 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33696 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2KAMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:55:55 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: nepomuk@kde.org
Subject: Re: [Nepomuk] Better support for (desktop) file search / indexing applications
Date: Thu, 1 Nov 2012 13:55:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.0-tp520; KDE/4.8.4; x86_64; ; )
Cc: Jan Kara <jack@suse.cz>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Eric Paris <eparis@redhat.com>,
        Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201211011352.42476.Martin@lichtvoll.de> (sfid-20121101_135310_030853_04871946)
In-Reply-To: <201211011352.42476.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211011355.54347.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. November 2012 schrieb Martin Steigerwald:
> Furthermore there is an issue with updating the file index on login or
> service start. In order to catch all other file renames a indexer would
> have to run over every directory whose modification time stamp has
> changed again in order to see whether a (checksummed) file has moved.
> 
> An approach like recursive mtime as proposed by Jan Kara can help to
> improve initial scan times a lot.
> 
> As to what I know this scan has been enabled in Nepomuk recently, with
> the hope that files are moved mainly during the user session is
> active. I think thats an assumption that may be accurate for many
> cases.

disabled, not enabled.

I read over this before but did not see the typo.

Sorry,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
