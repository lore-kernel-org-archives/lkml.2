Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2CLR5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:57:41 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:41819 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2CLR5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=AiEV5/S8vbAV4UwpDc9Rkidt3XmBFn1e
	wRn+oItcrtt5HnWUciFpd92/xaUmN/MWxMFBe6c68/IpUwHTJLHtfWqb6EGpFNlI
	CBgAoXPz7zeqTXOzGIpagxoKpDDBxgB0nHRiOCfjYuV5alJzRVd0lCPi67q1AeTZ
	QJPT6mutKmE=
From: Junio C Hamano <gitster@pobox.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, git@vger.kernel.org,
        Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu> <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu> <20120312152004.GB9380@kroah.com>
 <7vfwddu60f.fsf@alter.siamese.dyndns.org> <20120312164812.GC12405@1wt.eu>
Date: Mon, 12 Mar 2012 10:57:36 -0700
In-Reply-To: <20120312164812.GC12405@1wt.eu> (Willy Tarreau's message of
 "Mon, 12 Mar 2012 17:48:12 +0100")
Message-ID: <7v4nttu2gf.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: DAEF9890-6C6C-11E1-A723-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> Hi Junio,
>
> On Mon, Mar 12, 2012 at 09:40:48AM -0700, Junio C Hamano wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> > I don't see a -b option to 'git am' in the manpage, am I missing
>> > something here?
>> 
>> As this is a recent enhancement, it is very much appreciated if you
>> try out 1.7.10-rc0 (or 'master').
>
> I've just backported it to 1.7.9.3 (I'm not keen on living on the bleeding
> edge with my everyday tools), and it works nicely as expected.

This topic will be backported in later versions of 1.7.9.x track,
but living on the maintenance track does not have much smaller
chance of breakage than living on the tip of 'master' these days,
unless you are using distro packaged version. The usual rule of
thumb if you are compiling from the source is that the tip of
'master' is more stable than any tagged version, including the
maintenance track.  See

http://thread.gmane.org/gmane.comp.version-control.git/189657/focus=190814

for details.
