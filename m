Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab2BADo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:44:29 -0500
Received: from ozlabs.org ([203.10.76.45]:37338 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab2BADo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:44:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Danny Kukawka <danny.kukawka@bisect.de>,
        Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: [PATCH 05/16] cx18: fix handling of 'radio' module parameter
In-Reply-To: <201201311445.20095.danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de> <1327960820-11867-6-git-send-email-danny.kukawka@bisect.de> <201201311445.20095.danny.kukawka@bisect.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 01 Feb 2012 12:59:38 +1030
Message-ID: <87fwevjnfx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 14:45:18 +0100, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> On Dienstag, 31. Januar 2012, Andy Walls wrote:
> Overseen this. But wouldn't be the correct fix in this case to:
> a) reverse the part of 90ab5ee94171b3e28de6bb42ee30b527014e0be7 to:
>    get: 
>    static unsigned radio_c = 1;
>    
> b) change the following line:
>    module_param_array(radio, bool, &radio_c, 0644);
>    to:
>    module_param_array(radio, int, &radio_c, 0644);

Yes, sorry, my patch was complete crap here :(

If you want people to set it only to 1 or 0, you probably want "bint".

Thanks,
Rusty.
