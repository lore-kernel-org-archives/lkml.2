Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2EDJjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:39:33 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2817 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731Ab2EDJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:39:32 -0400
Message-ID: <1336124366.2046.20.camel@t41.thuisdomein>
Subject: Re: [v3.4-rc5]: drm references experimental
From: Paul Bolle <pebolle@tiscali.nl>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 04 May 2012 11:39:26 +0200
In-Reply-To: <CADDKRnA7XMczevE2JRsMR508mdz+Rgs+QvV4QCMqnts8t+1y3A@mail.gmail.com>
References: <CADDKRnDR=baZtQfyQLxYGB2zVDMGi2C_V2ffNkSUhipJB-+t=A@mail.gmail.com>
	 <1335995781.30754.27.camel@x61.thuisdomein>
	 <CADDKRnA7XMczevE2JRsMR508mdz+Rgs+QvV4QCMqnts8t+1y3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.1 (3.5.1-1.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 May 2012 09:39:26.0831 (UTC) FILETIME=[CBD9E7F0:01CD29D9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 14:02 +0200, Jörg Otte wrote:
> this means especially the following is not possible or does not occure:
> 
> NON-EXP:
> driver "A" uses library function "B"
> 
> EXP:
> unchanged driver "A" now uses EXPERIMENTAL function "B-EXP"

There's a number of things I can think of for "EXPERIMENTAL function".
What exactly do you mean here?

> The question is whether this is guaranteed.

If you were thinking about usage of CONFIG_EXPERIMENTAL in code or in
Makefiles: no, I don't think there's a guarantee that this won't be
done. But it should be clear that EXPERIMENTAL is intended as, say, a
tag for config options. So it's likely that usage of EXPERIMENTAL
outside that scope will be prevented.


Paul Bolle

