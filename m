Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1FHK0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:26:49 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34876 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1FHK0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:26:47 -0400
Date: Wed, 8 Jun 2011 12:26:43 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Marek =?utf-8?B?T2zFocOhaw==?= <maraeo@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Latest merge of 'drm-radeon-fixes' breaks my setup
Message-ID: <20110608102643.GA1711@x4.trippels.de>
References: <20110608054002.GA1717@x4.trippels.de>
 <20110608054354.GA1717@x4.trippels.de>
 <BANLkTinfn82C3TjPxzZuD+v=F+uCx8pmyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinfn82C3TjPxzZuD+v=F+uCx8pmyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.08 at 20:09 +1000, Dave Airlie wrote:
> On Wed, Jun 8, 2011 at 3:43 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2011.06.08 at 07:40 +0200, Markus Trippelsdorf wrote:
> >> The merge of the 'drm-radeon' branch by Linus yesterday breaks my setup
> >> (RS780). The mouse cursor is just a black block suddenly and I see an
> >> endless stream of:
> >>  radeon 0000:01:05.0: r600_check_texture_resource:1338 texture invalid format 26
> >>  [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> 
> This is wierd, can you try the attached patch, it appears this
> uncovered another bug.

Yes, your patch fixes the problem. Thanks Dave.

-- 
Markus
