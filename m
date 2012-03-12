Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2CLTvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:51:51 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:61440 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab2CLTvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=RF2hVxnQlUcwdoPA8FgVgx1peKHuvC1U
	Bstse/EnEhTmvMICeyRqFDb4ALDGONJfDrPNlHNi3e9+uqxkvCle+9twmPnKIlbH
	c/GD5vDNJtnDYgWrsJuG7UK94Hvtek2Ii/ICNWCbwWw6/5FezhvJtsjumxjp0gBo
	yUoAlH8isLU=
From: Junio C Hamano <gitster@pobox.com>
To: Greg KH <greg@kroah.com>
Cc: Willy Tarreau <w@1wt.eu>, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, git@vger.kernel.org,
        Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu> <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu> <20120312152004.GB9380@kroah.com>
 <7vfwddu60f.fsf@alter.siamese.dyndns.org> <20120312171257.GA25347@kroah.com>
 <7vzkblsnos.fsf@alter.siamese.dyndns.org> <20120312192627.GA24873@kroah.com>
Date: Mon, 12 Mar 2012 12:51:47 -0700
In-Reply-To: <20120312192627.GA24873@kroah.com> (Greg KH's message of "Mon,
 12 Mar 2012 12:26:27 -0700")
Message-ID: <7vty1tr418.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: CE19BD5C-6C7C-11E1-B0CF-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Mar 12, 2012 at 11:01:55AM -0700, Junio C Hamano wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> > Does the flag propagate from 'git quiltimport'?
>> 
>> I didn't even know the script was shipped as part of the main
>> Porcelain until I looked.  I do not think anybody is maintaining it;
>> the last update was from the 1.6.2 era.
>
> Ah, so my feeling that I'm the only one using it is true :)
>
>> A tested patch from quilt stakeholders is very much welcomed.
>
> I'll be glad to maintain this if you need me to.  I'll poke around with
> it tomorrow to see what needs to be done here.

Surely, and thanks.
