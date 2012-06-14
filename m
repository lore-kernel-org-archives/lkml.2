Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2FNS3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:29:35 -0400
Received: from hera.cwi.nl ([192.16.191.8]:61444 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab2FNS3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:29:33 -0400
Message-ID: <4FDA2D7E.8010109@cwi.nl>
Date: Thu, 14 Jun 2012 19:29:18 +0100
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        Dave Airlie <airlied@gmail.com>, intergalactic.anonymous@gmail.com,
        len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>,
        "Wilson, Chris" <chris.wilson@intel.com>
Subject: Re: [3.4 regression] [bisected] DisplayPort fails to come on
References: <4FD9E69A.4090708@cwi.nl> <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com> <CAKMK7uGokt5cW0R+LKXRmE_kecqmnv4Zgy-WiSZA-GPP8htE-A@mail.gmail.com> <4FD9F9B0.9030204@cwi.nl> <4FDA1C03.3020404@cwi.nl> <CAKMK7uESK+CPkXVA5wFjL5B_38AAFnZLX6pY2aRfAYyWZAZ5nA@mail.gmail.com>
In-Reply-To: <CAKMK7uESK+CPkXVA5wFjL5B_38AAFnZLX6pY2aRfAYyWZAZ5nA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 06:27 PM, Daniel Vetter wrote:
> Well, can you revert this patch (or just replace the 5 with 3 in the
> code) on top of latest 3.4.x and test whether this is indeed the cause
> of your regression? Just to make sure that we have the right culprit.
Hi Daniel,

Yes, 3.4.2 with 092945e11c5b84f66dd08f0b87fb729715d377bc  does enable 
the screen.

With kind regards,

Wouter
