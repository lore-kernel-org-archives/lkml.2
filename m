Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab2KIIbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:31:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2KIIbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:31:22 -0500
Date: Fri, 9 Nov 2012 09:32:03 +0100
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121109093203.4358eaf2@doriath>
In-Reply-To: <20121107105348.GA25549@lizard>
References: <20121107105348.GA25549@lizard>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Wed, 7 Nov 2012 02:53:49 -0800
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> Hi all,
> 
> This is the third RFC. As suggested by Minchan Kim, the API is much
> simplified now (comparing to vmevent_fd):

Which tree is this against? I'd like to try this series, but it doesn't
apply to Linus tree.
