Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2DZI0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:26:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab2DZI0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:26:43 -0400
Message-ID: <4F9906C0.3030109@suse.cz>
Date: Thu, 26 Apr 2012 10:26:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jiri Kosina <trivial@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] .gitignore: Ingore rejected patch results
References: <1335422590-12124-1-git-send-email-namhyung.kim@lge.com>
In-Reply-To: <1335422590-12124-1-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.4.2012 08:43, Namhyung Kim wrote:
> Let git ignores *.rej files created when patch failed.

I am not sure this is a good idea. If a patch fails and I have .rej
files around, I really want to know about them.

Michal
