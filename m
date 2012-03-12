Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2CLGtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:49:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42063 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2CLGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:49:05 -0400
Date: Mon, 12 Mar 2012 01:48:55 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org, Thomas Rast <trast@student.ethz.ch>
Subject: stripping [PATCH] without losing later tags from mailed patches (Re:
 [ 02/12] Remove COMPAT_IA32 support)
Message-ID: <20120312064855.GB16820@burratino>
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye>
 <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312063027.GB8971@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(adding git list and Thomas to cc)
Willy Tarreau wrote:
> On Sun, Mar 11, 2012 at 07:49:48PM -0700, Greg KH wrote:
>> On Mon, Mar 12, 2012 at 01:07:26AM +0000, Ben Hutchings wrote:

>>> The subject/first line should include '[IA64]', as in the original
>>> commit.  It looks like this has been automatically stripped.
>>
>> Yeah, munging patches to and from quilt and git will cause that to
>> happen at times, it's quite common :(
>
> Indeed, and I've even changed my patch formats in haproxy to avoid brackets
> due to this issue. The cause is that many patches are sent with a [PATCH]
> prefix and that with Git, either you keep the subject line intact or you
> remove everything that is between brackets. There's the -b option to only
> remove remove tags looking like [PATCH], but my general experience with it
> was not satisfying (I don't remind why).

Maybe the problem was as simple as "git am" not knowing about "-b".

Two relevant patches:

  f7e5ea17 (am: learn passing -b to mailinfo, 2012-01-16)
  ee2d1cb4 (mailinfo: with -b, keep space after [foo], 2012-01-16)

are in "master" and 1.7.10-rc0 and were not part of any earlier release.

Kudos to Thomas for writing them.

Jonathan
