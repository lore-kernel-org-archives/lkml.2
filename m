Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935Ab2DKTSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:18:55 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56251 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2DKTSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120411191325.GL12044@thunk.org>
References: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
	<20120411045107.GA324@x4>
	<20120411180520.GE12044@thunk.org>
	<20120411182856.GA327@x4>
	<20120411191325.GL12044@thunk.org>
Date: Wed, 11 Apr 2012 12:18:52 -0700
Message-ID: <CAMe9rOrhJR1Gg02hGmXHE8prtTeZvS6JuR6q=waM3iSNLKFpuw@mail.gmail.com>
Subject: Re: Trying to make a working kernel with the gold linker
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, hjl.tools@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:13 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 11, 2012 at 08:28:56PM +0200, Markus Trippelsdorf wrote:
>>
>> Just compiling and installing a new binutils version should work fine.
>>
>> (But you should nonetheless consider to also upgrade gcc, because
>> gcc-4.4 is ancient and not even officially maintained anymore...)
>
> Well *someone* has to still make sure the kernel compiles correctly on
> the enterprise distro's that a huge number of Linux users use...
> (including RHEL 6, Debian Stable, SLES 11, Ubuntu LTS 10.04, etc.)
>
> :-)
>
> But yeah, I hope to get off of Ubuntu LTS real soon now, and onto
> something a bit more hip, such as Debian testing.
>
>                                                - Ted

To build Linux kernel with gold, you should at least try gold in
binutils 2.22.

-- 
H.J.
