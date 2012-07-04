Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2GDLdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:33:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50941 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2GDLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:33:51 -0400
Date: Wed, 4 Jul 2012 14:33:39 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
Message-ID: <20120704143339.513439b4@pixies.home.jungo.com>
In-Reply-To: <4FF4005E.1070106@nod.at>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	<4FF4005E.1070106@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2012 10:35:42 +0200 Richard Weinberger <richard@nod.at> wrote:
> Has this patch set an impact on UBI fastmap?

Not sure yet. Maybe. Need to medidate on this :-)

> ...wondering why I'm CC'd. :-)

Heads-up.
As this is a bit delicate, you may review if the parts modified relate
to your fastmap work.

Regards,
Shmulik
