Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2BCT1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:27:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39305 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391Ab2BCT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:27:11 -0500
Date: Fri, 3 Feb 2012 19:27:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tim Gardner <rtg.canonical@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Linux 3.2.3
Message-ID: <20120203192708.GC23505@opensource.wolfsonmicro.com>
References: <20120203174758.GA18584@kroah.com> <4F2C2A40.1080601@canonical.com> <20120203185157.GA2865@kroah.com> <20120203185319.GA1710@kroah.com> <20120203185459.GA7321@kroah.com> <4F2C3161.5020807@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2C3161.5020807@canonical.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:11:29PM -0700, Tim Gardner wrote:
> On 02/03/2012 11:54 AM, Greg KH wrote:

>> Mark, any objection to me just reverting the SOC patch that causes this build
>> failure instead?

> I think you'll have to revert both WM5100 patches that came in with v3.2.3:

Well, we should substitute in the version using the then-current APIs
but that can easily be done as a revert then add.

Sorry, I had misremembered and thought that the regmap conversion had
been done in 3.2 along with the initial support for regmap devices in
ASoC.  It must've been done but only actually applied in 3.3.
