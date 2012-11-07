Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2KGL2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:28:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41115 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2KGL2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:28:14 -0500
MIME-Version: 1.0
In-Reply-To: <20121107112136.GA31715@shutemov.name>
References: <20121107105348.GA25549@lizard>
	<20121107112136.GA31715@shutemov.name>
Date: Wed, 7 Nov 2012 13:28:12 +0200
X-Google-Sender-Auth: 865x4L21GRXIzL-zV97O3t5rgjc
Message-ID: <CAOJsxLHY+3ZzGuGX=4o1pLfhRqjkKaEMyhX0ejB5nVrDvOWXNA@mail.gmail.com>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
From: Pekka Enberg <penberg@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 1:21 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>> While the new API is very simple, it is still extensible (i.e. versioned).
>
> Sorry, I didn't follow previous discussion on this, but could you
> explain what's wrong with memory notifications from memcg?
> As I can see you can get pretty similar functionality using memory
> thresholds on the root cgroup. What's the point?

Why should you be required to use cgroups to get VM pressure events to
userspace?
