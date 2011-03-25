Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1CYNpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:45:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61029 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1CYNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LO8oEXppfuvzoItpU2dVxyDGhgt3fyUD2sPH7+er4Vq9EjzFGdBFZ1VtxNIx/BGkSy
         zJDqzU7vahtdISh5kuC/M12gHV+DiRT8vfMSYW/5U0UKbSVxkJVpLjfYsFZizf/DKELT
         7ZZ+fD003E5BtODC+0pt7nqPdsjDp4ueWdd2s=
MIME-Version: 1.0
In-Reply-To: <BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110324105222.GA2625@barrios-desktop>
	<20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
	<20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
Date: Fri, 25 Mar 2011 09:45:15 -0400
X-Google-Sender-Auth: szfEh8catdOQxhmi167W31gB9rU
Message-ID: <AANLkTin51sZ2fsOzfaSWQCWkrQ+JkyVWNnM022E2GFwQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
From: Colin Walters <walters@verbum.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there anything here that couldn't be solved with a proper cgroups
configuration?  In fact, wasn't this type of problem the original
cgroups motivation?
