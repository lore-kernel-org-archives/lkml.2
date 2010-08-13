Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0HMWgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:36:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33233 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab0HMWgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=O39Qw5M0VFw0eHZHbGMGlY2IGzu9DJ0znBHkXlJCOL28Q0XrI27NMZHjk1PSLvutHz
         0ZyygFzQIFEM6eljPCuPxp7168QixxMlZNiaFv0wb/b27IT+ci9li/uo2zuUwwIciKpO
         gkGW62wCJ1Mf7dapIwwnbECBkwLJu0HfUmTLs=
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [0/3] 2.6.27.52 stable review
Date: Sat, 14 Aug 2010 08:36:34 +1000
Organization: scattered
Message-ID: <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
References: <20100813214704.GA18960@kroah.com>
In-Reply-To: <20100813214704.GA18960@kroah.com>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 14:47:04 -0700, you wrote:

>NOTE!
>
>If I could get some people to please test this -rc release?  It contains
>a few core changes that I couldn't validate myself as I don't seem to
>have a machine that will even boot the .27 kernel anymore after my move.

I surely will, just as soon as the thing appears ;)  Ftp and http 
return nothing just now.

Grant.
>
>I didn't want to include them in the last .27-stable release because of
>this, so any testing is much appreciated.  Especially if you happen to
>run across any signal and/or stack issues that might be floating around
>in the ether...
>
>----
>
>This is the start of the stable review cycle for the 2.6.27.52 release.
>There are 3 patches in this series, all will be posted as a response to
>this one.  If anyone has any issues with these being applied, please let
>us know.  If anyone is a maintainer of the proper subsystem, and wants
>to add a Signed-off-by: line to the patch, please respond with it.
>
>Responses should be made by Monday, August 16, 2010, 20:00:00 UTC.
>Anything received after that time might be too late.
>
>The whole patch series can be found in one patch at:
>	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.52-rc1.gz
>and the diffstat can be found below.
>
>thanks,
>
>greg k-h
>
> Makefile            |    2 +-
> arch/x86/mm/fault.c |    9 ++++++++-
> mm/memory.c         |   25 +++++++++++++++++++++++++
> 3 files changed, 34 insertions(+), 2 deletions(-)
