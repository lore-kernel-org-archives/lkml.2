Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0KINx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:53:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0KINxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:53:55 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wSgS5G9fFx4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=HmHud4z9__jyDSQnSY8A:9 a=TZ6kOg1snFtjTjXfyuJTbkQH9RwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [v2 PATCH] ftrace: Speed up recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        John Reiser <jreiser@bitwagon.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <AANLkTimS7YsZo+AGyTJq+G4kqsviRMRbdgt3NqZgEUws@mail.gmail.com>
References: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>
	 <4CC9E5B5.5040402@suse.cz>
	 <AANLkTimS7YsZo+AGyTJq+G4kqsviRMRbdgt3NqZgEUws@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 09 Nov 2010 08:53:52 -0500
Message-ID: <1289310832.12418.88.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 13:35 +0800, wu zhangjin wrote:

> Did you apply this patch, should I fix this typo and resend it to you?

I applied it, but during testing it triggered a bug in the build system.

I'm looking into it. It is not really related to this patch, but I can't
submit it till the build is fix.

Also, since it is not that critical of a patch, I think I'll queue it
for 2.6.38, just to be safe.

Thanks,

-- Steve


