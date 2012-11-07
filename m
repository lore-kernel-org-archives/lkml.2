Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2KGUxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:53:02 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42950 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2KGUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:52:59 -0500
Message-ID: <509ACA28.307@kernel.org>
Date: Wed, 07 Nov 2012 22:52:56 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
References: <20121107105348.GA25549@lizard> <20121107112136.GA31715@shutemov.name> <xr93liedfhy4.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93liedfhy4.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 11/7/12 7:20 PM, Greg Thelen wrote:
 > Related question: are there plans to extend this system call to
 > provide per-cgroup vm pressure notification?

Yes, that's something that needs to be addressed before we can ever
consider merging something like this to mainline.  We probably need help
with that, though. Preferably from someone who knows cgroups. :-)

                         Pekka
