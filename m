Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1IGRAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:00:14 -0400
Received: from gw1.transmode.se ([195.58.98.146]:52607 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1IGRAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:00:11 -0400
In-Reply-To: <4E5EF5F9.9020006@systemfabricworks.com>
References: <20110831213729.395283830@systemfabricworks.com> <4E5EF5F9.9020006@systemfabricworks.com>
Subject: Re: [PATCH v6 08/10] crc32-add-slicing-by-8.diff
X-KeepSent: D88E4684:19565F7D-C1257904:0029574E;
 type=4; name=$KeepSent
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFD88E4684.19565F7D-ONC1257904.0029574E-C1257904.002970DD@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 7 Sep 2011 09:32:38 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/07/2011 09:32:39
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Pearson <rpearson@systemfabricworks.com> wrote on 2011/09/01 05:03:21:
>
> I've been looking at this stuff for too long! I just noticed that
> crc32_body incorrectly always uses CRC_LE_BITS to pick algorithm.
> Replace with a function parameter that will get optimized out
> by the compiler since crc32_body is inlined.

yes, this is a nice change.

 Jocke

