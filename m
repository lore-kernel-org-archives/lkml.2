Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2JYGo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:44:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37087 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2JYGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <20121025064009.GA15767@bbox>
References: <20121022111928.GA12396@lizard>
	<20121025064009.GA15767@bbox>
Date: Thu, 25 Oct 2012 09:44:52 +0300
X-Google-Sender-Auth: A1OOOIMZ9-CtEmpqtQdPXmPxDFg
Message-ID: <CAOJsxLGsjTe13WjY_Q=BLBELwQXOjuwo7PiEKwONHUfR4mQmig@mail.gmail.com>
Subject: Re: [RFC v2 0/2] vmevent: A bit reworked pressure attribute + docs +
 man page
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 9:40 AM, Minchan Kim <minchan@kernel.org> wrote:
> Your description doesn't include why we need new vmevent_fd(2).
> Of course, it's very flexible and potential to add new VM knob easily but
> the thing we is about to use now is only VMEVENT_ATTR_PRESSURE.
> Is there any other use cases for swap or free? or potential user?
> Adding vmevent_fd without them is rather overkill.

What ABI would you use instead?

On Thu, Oct 25, 2012 at 9:40 AM, Minchan Kim <minchan@kernel.org> wrote:
> I don't object but we need rationale for adding new system call which should
> be maintained forever once we add it.

Agreed.
