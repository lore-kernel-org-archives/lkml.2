Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1KBWaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:30:09 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:57426 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1KBWaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=tt0c6NL5dPy2P0P1bLyeJ3fyfvrWRhov
	X9OBW6S/830lrY5tH9hd2bX1LDrDVgCpEzJGPe4F/z5OggzrhMpydEm6qf52YT+q
	iMrI1dS/ImLlgW+Z4IRQy9rcwdMQODTVONQZ7I0+1wa3ReQXbgsAUgI29gzzXN4I
	QFE0BrzKaHA=
From: Junio C Hamano <gitster@pobox.com>
To: Stefan Roas <sroas@roath.org>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.7.2
References: <7v7h3jl3kw.fsf@alter.siamese.dyndns.org>
 <20111102214725.GA2860@geminga.roas.networks.roath.org>
Date: Wed, 02 Nov 2011 15:30:01 -0700
In-Reply-To: <20111102214725.GA2860@geminga.roas.networks.roath.org> (Stefan
 Roas's message of "Wed, 2 Nov 2011 22:47:25 +0100")
Message-ID: <7v1utqi2dy.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 3581956A-05A2-11E1-9146-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Roas <sroas@roath.org> writes:

> is it possible that you forgot to update the GIT-VERSION-GEN with the
> release of 1.7.7.2? I stll get version 1.7.7.1 from the tarball on
> http://git-scm.com/ and when building from the git repository itself.

Probably.
