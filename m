Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2KHDTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 22:19:31 -0500
Received: from wolff.to ([65.117.131.163]:35522 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752485Ab2KHDTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 22:19:30 -0500
Date: Wed, 7 Nov 2012 21:18:38 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Only sign modules if built in-tree
Message-ID: <20121108031838.GA24194@wolff.to>
References: <87390t6bs0.fsf@rustcorp.com.au>
 <20121101112655.GM6627@hansolo.jdub.homelinux.org>
 <20121101145013.GN6627@hansolo.jdub.homelinux.org>
 <87liek4rt5.fsf@rustcorp.com.au>
 <20121102123404.GO6627@hansolo.jdub.homelinux.org>
 <87vcdkyfi4.fsf@rustcorp.com.au>
 <20121105191903.GG27352@hansolo.jdub.homelinux.org>
 <87a9uv5xbp.fsf@rustcorp.com.au>
 <20121106125417.GI27352@hansolo.jdub.homelinux.org>
 <20121107192141.GA4615@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20121107192141.GA4615@wolff.to>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 13:21:41 -0600,
   Bruno Wolff III <bruno@wolff.to> wrote:
>
>I tested building dahdi-linux with kernel-3.7.0-0.rc4.git1.1.fc19 
>which has this patch and the build went fine. I won't be able to test 
>that the module works until tonight, but even if it ends up being 
>broken the signing patch is unlikely to be the cause.

The module seems to be working correctly. So everything looks good.
