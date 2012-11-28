Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2K1Vql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:46:41 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:42866 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2K1Vqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:46:40 -0500
Message-ID: <50B6863B.5010002@cesarb.net>
Date: Wed, 28 Nov 2012 19:46:35 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/24] MAINTAINERS: adjust for UAPI
References: <1353716808-16375-8-git-send-email-cesarb@cesarb.net> <1353716808-16375-1-git-send-email-cesarb@cesarb.net> <26215.1354108760@warthog.procyon.org.uk>
In-Reply-To: <26215.1354108760@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-11-2012 11:19, David Howells escreveu:
> Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
>
>> Several headers were moved or split to uapi/.
>
> I was going to wait to do this till all the bits have got upstream.  Several
> are still wending their way through maintainer trees.  Feel free to send your
> patch to Linus with:

I think I will wait for your patch. Since you probably created it with 
the same scripts used for the original move to uapi/, it should have 
less chance of mistakes than my ad-hoc shell scripting.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
