Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1KKQKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:10:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab1KKQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
References: <4EBC0696.9030103@parallels.com>
	<4EBC06DB.3090202@parallels.com>
	<20111110184654.GA1006@redhat.com>
	<20111110185603.GA1757@redhat.com>
	<4EBCF4E7.4090002@parallels.com>
	<20111111152532.GA22640@redhat.com>
	<4EBD461E.1000106@parallels.com>
	<CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
Date: Fri, 11 Nov 2011 08:10:18 -0800
X-Google-Sender-Auth: 1yRoLAEjs93spkgtjiV8nWCgJSU
Message-ID: <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given pids
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's highly unlikely that the ability to fork in parallel would
> contribute to any meaningful speedup. That is not the critical path by
> *far*

To add a bit, it's also one of the more *serialized* path. Doing it in
parallel might actually hurt, so if losing the ability to do it makes
it less intrusive, that's the better way.

-- 
tejun
