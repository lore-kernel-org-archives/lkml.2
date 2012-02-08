Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2BHSK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:10:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab2BHSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:10:28 -0500
Date: Wed, 8 Feb 2012 13:10:15 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: 3.3-rc2 snd_pcm lockdep backtrace
Message-ID: <20120208181014.GA6188@zod.bos.redhat.com>
References: <20120206145621.GA4771@zod.bos.redhat.com>
 <201202081854.08668.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201202081854.08668.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 06:54:08PM +0100, Maciej Rutecki wrote:
> On poniedziałek, 6 lutego 2012 o 15:56:22 Josh Boyer wrote:
> 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=42746
> for your bug report, please add your address to the CC list in there, thanks!

Er... why exactly?

I mean, great I don't really mind at all that a bugzilla.kernel.org bug
was opened, but

1) there's already a bug opened in the RH bugzilla for this
2) I've already emailed the upstream developers and list about it
3) ALSA actually has it's own bug tool

so unless the ALSA devs are going to do something with that particular
bug I don't see a huge amount of value.

As an aside, I'm basically an intermediary here.  The original reporter
in the RHT bug should probably add their email to CC.

josh
