Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab2EIFsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:48:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60280 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2EIFsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:48:42 -0400
Date: Tue, 8 May 2012 22:48:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 00/14 v3] cleanup atmel_mxt_ts
Message-ID: <20120509054836.GE10514@core.coreip.homeip.net>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <CAGS+omDm36Sxpv_e1=W6BNx9EoeWd1H2EaPqHAaGYYWnaZjZAw@mail.gmail.com>
 <20120505121626.GA754@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120505121626.GA754@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sat, May 05, 2012 at 02:16:26PM +0200, Henrik Rydberg wrote:
> 
> > >  Input: atmel_mxt_ts - verify object size in mxt_write_object
> 
> OK, also stable material.

No, I don't think we need it in stable as it is not exposed to
unprivileged userspace and we did not have reports of it causing
issues...

Daniel,

I applied patches 1, 2, 4, 5, and 6. The rest seem to need more
discussion.

Thanks.

-- 
Dmitry
