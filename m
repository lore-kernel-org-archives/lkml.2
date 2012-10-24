Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111Ab2JXO7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:59:42 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57066 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994Ab2JXO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:59:40 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ian Kent <raven@themaw.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	<87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
	<1348447130.2318.1.camel@perseus.themaw.net>
	<87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
	<1348537604.2307.8.camel@perseus.themaw.net>
	<87mx0estch.fsf@xmission.com>
	<1349926483.2371.35.camel@perseus.themaw.net>
Date: Wed, 24 Oct 2012 16:59:36 +0200
In-Reply-To: <1349926483.2371.35.camel@perseus.themaw.net> (Ian Kent's message
	of "Thu, 11 Oct 2012 11:34:43 +0800")
Message-ID: <87625z531j.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ian Kent <raven@themaw.net> writes:
> 
> > Yeah, the problem with that is that "autofs doesn't work if containers
> > are used" is ill defined since there are use cases where it does, I
> > believe. At the very least, ill defined in my view of things.

Customer says:

 "There is no interaction between host and the conatainer.  The host use
  only his own automount and each containers used automount in their
  container."

I think it's a pretty clearly defined use case.  And one which automount
could easily support since the only requirement is that all namespaces
are treated equally.

But I agree that adding safeguards against cases which don't have such
easily defined semantics (such as triggers from several different
namespaces).

I'll post updated patches.

Thanks,
Miklos

