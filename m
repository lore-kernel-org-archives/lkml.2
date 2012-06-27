Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab2F0SFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:05:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab2F0SFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:05:54 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XOt6boVe9ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=n9gTl2mg8W56Y4s2eZsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340820352.16702.41.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Date: Wed, 27 Jun 2012 14:05:52 -0400
In-Reply-To: <CAJL_eks3n3J3nkfYJLx=hbQ36utjodByr=z-q=s-uwWpvWmDXg@mail.gmail.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
	 <1340060577-9112-1-git-send-email-dhsharp@google.com>
	 <1340293617.27036.177.camel@gandalf.stny.rr.com>
	 <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
	 <1340407900.27036.275.camel@gandalf.stny.rr.com>
	 <CAJL_eksV6R2Je+qoBYAtvZ6pSb8d6HdNiBic7AH0TG3u2R0FzQ@mail.gmail.com>
	 <CAJL_eksSXfq4RVZ_rHagpgex96Jq=QkpiW93hD7M5xoYscq2jQ@mail.gmail.com>
	 <1340801169.16702.9.camel@gandalf.stny.rr.com>
	 <CAJL_eks3n3J3nkfYJLx=hbQ36utjodByr=z-q=s-uwWpvWmDXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 11:00 -0700, David Sharp wrote:

> I just meant, do you want me to send you a version of your patch with
> my description (I'll update it, obviously), or do it yourself.

I'll do it. Although, I think this may just go for 3.6 and not 3.5, as
the bug is really minor.

> I have always disliked that page of very old data, so I'm really happy
> that this will get rid of it. As I recall, you once claimed this was a
> "feature". :)

Of course it was a feature. But we'll just act like Gnome and remove
it ;-)

-- Steve


