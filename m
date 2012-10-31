Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab2JaJlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:41:05 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1262 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab2JaJk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:40:57 -0400
Message-ID: <1351676454.1339.99.camel@x61.thuisdomein>
Subject: Re: NULL pointer dereference at fat_detach
From: Paul Bolle <pebolle@tiscali.nl>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@parisplace.org>
Date: Wed, 31 Oct 2012 10:40:54 +0100
In-Reply-To: <87y5in8nys.fsf@devron.myhome.or.jp>
References: <20121030134449.GA5435@redhat.com>
	 <1351632646.1339.72.camel@x61.thuisdomein>
	 <87y5in8nys.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2012 09:40:55.0092 (UTC) FILETIME=[D2D07740:01CDB74B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 09:49 +0900, OGAWA Hirofumi wrote:
> This bug is known as the inotify bug. I recall I talked about this,
> maybe years ago.

Would that be this thread: https://lkml.org/lkml/2011/6/10/155 ?


Paul Bolle

