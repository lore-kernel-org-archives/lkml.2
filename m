Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2H2XDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:03:36 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:3279 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130Ab2H2XDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:03:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAG6Zu08YNPuJ/2dsb2JhbAANN4UtsgEBAQEBAyNVARALGAICBRYLAgIJAwIBAgFFBg0BBQIBAa8YknuBJo4KgRQDqBA
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="197034866"
Message-ID: <503E9FC5.1010707@teksavvy.com>
Date: Wed, 29 Aug 2012 19:03:33 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: wbrana <wbrana@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <201208231951.28606.linux@rainbow-software.org> <CAJ7jCmnwXNXmoxT6sdOc-8znsUnnW+Rq8ioJ_8B8KnT0K2uc=A@mail.gmail.com> <1345812057.28613.20.camel@thorin> <CAJ7jCm=bZoHS0-qiiJnUjZb3gP6ibo1xbLsmaUJr2rL4pAU8Eg@mail.gmail.com> <1345823281.28613.34.camel@thorin> <CAJ7jCmmYdQacFtzw+ukGAtrUntnn8S869RcCmbt3cVRY7HYOWw@mail.gmail.com> <CANQmPXgefyCJuzFiAugp6OW2+HtjABSWuQqG33gAU_XgQ1V_2A@mail.gmail.com> <CAJ7jCmme5VNO9aX0SVtmVGUdJj4QODRE4+oPxBE62yCRKcVK6w@mail.gmail.com> <20120824173626.0194625c@pyramind.ukuu.org.uk> <CAJ7jCmmmMx_OmzE_6Gw7Rf3=Sqa3MWiU4FusJ79PQr2fApMUwA@mail.gmail.com> <20120824174712.16c75f31@pyramind.ukuu.org.uk> <CAJ7jCmkAV=u4jxWfdTGXhsvmCbck7eHVLVPua4=1VjXLig4sHA@mail.gmail.com> <503A2B04.7080703@teksavvy.com> <CAJ7jCm=A+OOQNq3HYsyM9bVXYQbfxkXaJg+yN_-vyA+VM9-jgQ@mail.gmail.com>
In-Reply-To: <CAJ7jCm=A+OOQNq3HYsyM9bVXYQbfxkXaJg+yN_-vyA+VM9-jgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-26 10:15 AM, wbrana wrote:
> On 8/26/12, Mark Lord <kernel@teksavvy.com> wrote:
>> Here are a couple of real scenarios you don't seem to have thought about.
>> A 32-bit kernel on a legacy (or even new) system in 2017 will still need
>> regular kernel updates (not "long term" un0maintained kernels)
>> in order to work with new USB devices, new 4KB+ sector hard drives,
>> newer generations of SSDs, etc..
> 12-years-old machine is trash.

There you go making assumptions again.
Who said anything about a 12-year old machine?

Much more likely is a 5-year old software installation
that gets moved to a new box.


