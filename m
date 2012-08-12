Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2HLNcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 09:32:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48493 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2HLNcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 09:32:03 -0400
Message-ID: <5027B04D.3090703@gmail.com>
Date: Sun, 12 Aug 2012 15:31:57 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, ap@solarrain.com
Subject: Re: 3.4->(3.5.1 || 3.6-rc1) => can no longer mount 60TB ext4 filesystem
References: <005501cd77e7$d222d020$76687060$@lucidpixels.com>
In-Reply-To: <005501cd77e7$d222d020$76687060$@lucidpixels.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.08.2012 19:36, Justin Piszcz wrote:
> Hello,
> 
> I upgrade to each new kernel release and with 3.5.1 (from 3.4) I can no
> longer mount my 60TB ext4 volume.
> If I boot back to 3.4, it works fine.
> 
> Details here:
> https://lkml.org/lkml/2012/8/10/205
> 
> Anything I can do besides testing each 3.5-rcX to find where the regression
> lies?

I'm not at all familiar with ext4 internals, but as always, an wasy way
is to bisect such a problem. Any change you can do that?

  http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html


Daniel

