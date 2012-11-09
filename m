Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2KIJH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:07:57 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34455 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KIJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:07:47 -0500
Date: Fri, 9 Nov 2012 01:04:40 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121109090440.GA20998@lizard>
References: <20121107105348.GA25549@lizard>
 <20121109093203.4358eaf2@doriath>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121109093203.4358eaf2@doriath>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 09:32:03AM +0100, Luiz Capitulino wrote:
> Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> > This is the third RFC. As suggested by Minchan Kim, the API is much
> > simplified now (comparing to vmevent_fd):
> 
> Which tree is this against? I'd like to try this series, but it doesn't
> apply to Linus tree.

Thanks for trying!

The tree is a mix of Pekka's linux-vmevent tree and Linus' tree. You can
just clone my tree to get the whole thing:

	git://git.infradead.org/users/cbou/linux-vmevent.git

Note that the tree is rebasable. Also be sure to select CONFIG_VMPRESSURE,
not CONFIG_VMEVENT.

Thanks!
Anton.
