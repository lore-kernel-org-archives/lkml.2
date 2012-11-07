Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2KGLbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:31:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65097 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2KGLbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:31:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFz+Zi=A0uyuNMj411ngjwpstakNY3fEWy6tW_h4whr7w@mail.gmail.com>
References: <20121107105348.GA25549@lizard>
	<CAOJsxLFz+Zi=A0uyuNMj411ngjwpstakNY3fEWy6tW_h4whr7w@mail.gmail.com>
Date: Wed, 7 Nov 2012 13:31:30 +0200
X-Google-Sender-Auth: 6TbOxurxrd5-jH1euUvVpIS31jg
Message-ID: <CAOJsxLGKsGVRosthKs2JfNro7dGAtZxZt-E2SWzq6wTpJN+wKg@mail.gmail.com>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>,
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

On Wed, Nov 7, 2012 at 1:30 PM, Pekka Enberg <penberg@kernel.org> wrote:
> I love the API and implementation simplifications but I hate the new
> ABI. It's a specialized, single-purpose syscall and bunch of procfs
> tunables and I don't see how it's 'extensible' to anything but VM

s/anything but VM/anything but VM pressure notification/
