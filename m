Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2LESrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:47:17 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:49749 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab2LESrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:47:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=Sn3L3SfcCEsrB90Xc1pT44c4i7y1hWp3
	l9S/yYJlLH4v1zffCm6eyWtNKfz5cR7+sHMtFQci5RwFLP2romuSrXIbdta3DovU
	+CQm3Yxcpu+CNKbKZW7eIKZobancFnIfza1lBnfMW5qy3ztD7w/qAlWu8DFvvMPs
	46cG/dDgU/4=
From: Junio C Hamano <gitster@pobox.com>
To: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.8.1-rc0
References: <7vip8iq1vs.fsf@alter.siamese.dyndns.org>
 <50BF9544.7060401@ramsay1.demon.co.uk>
Date: Wed, 05 Dec 2012 10:47:11 -0800
In-Reply-To: <50BF9544.7060401@ramsay1.demon.co.uk> (Ramsay Jones's message
 of "Wed, 05 Dec 2012 18:41:08 +0000")
Message-ID: <7v1uf4l4k0.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 2EE1A3F4-3F0C-11E2-B8AB-995F2E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramsay Jones <ramsay@ramsay1.demon.co.uk> writes:

> I fetch git from 'git://git.kernel.org/pub/scm/git/git.git' which has
> commit ee26a6e2 ("Git 1.8.1-rc0", 03-12-2012), but is missing the v1.8.1-rc0
> tag. Is this just an oversight ...

Thanks for letting me know; forgot to push out the tag.


