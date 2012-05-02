Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2EBDwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:52:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41628 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2EBDwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:52:00 -0400
Date: Tue, 1 May 2012 20:50:35 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Glauber Costa <glommer@parallels.com>, kamezawa.hiroyu@jp.fujitsu.com,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
Message-ID: <20120502035035.GA18787@lizard>
References: <20120418083523.GB31556@lizard>
 <alpine.LFD.2.02.1204182259580.11868@tux.localdomain>
 <20120418224629.GA22150@lizard>
 <alpine.LFD.2.02.1204190841290.1704@tux.localdomain>
 <20120419162923.GA26630@lizard>
 <20120501131806.GA22249@lizard>
 <4FA04FD5.6010900@redhat.com>
 <20120502002026.GA3334@lizard>
 <4FA08BDB.1070009@gmail.com>
 <20120502033136.GA14740@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120502033136.GA14740@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:31:36PM -0700, Anton Vorontsov wrote:
[...]
> p.s. I'm not the vmevents author, plus I use both memcg and
> vmevents. That makes me think that I'm pretty unbiased here. ;-)

...though, that doesn't mean I'm right, of course. :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
